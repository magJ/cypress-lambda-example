FROM public.ecr.aws/lambda/nodejs:16

# Cypress dependencies, and binutils for patching binary
RUN yum install -y \
    xorg-x11-server-Xvfb \
    gtk2-devel \
    gtk3-devel \
    libnotify-devel \
    GConf2 \
    nss \
    libXScrnSaver \
    alsa-lib \
    binutils && \
    yum clean all

# Install chromium, not nessesary if using cypress's embedded electron
RUN yum install -y \
    amazon-linux-extras && \
    amazon-linux-extras install epel -y && \
    yum install -y \
    chromium && \
    yum clean all

# Cypress needs to be installed in a location that is readable by unprivleged lambda users
ENV CYPRESS_CACHE_FOLDER=/opt/cypress
ENV XDG_CONFIG_HOME=/tmp
RUN mkdir $CYPRESS_CACHE_FOLDER

COPY package.json package-lock.json ./
# Patches Cypress electron binary to not use /dev/shm
COPY patch-cypress.sh .
RUN npm i && chmod -R +r $CYPRESS_CACHE_FOLDER && ./patch-cypress.sh

COPY cypress.config.ts tsconfig.json ./
COPY tests ./tests
COPY src ./src
RUN npx cypress verify
RUN npx tsc
RUN rm cypress.config.js

# Only used for local testing of unprivleged users, lambda will create it's own user
RUN /sbin/adduser testuser

CMD ["src/lambdaHandler.handler"]
