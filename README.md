# Cypress on AWS lambda example

A demonstration of how to run cypress on AWS lambda, using chromium.

I've tried to make this as minimal as possible, but there might be some ways this could be simplified further.

## Building and running this example yourself
`build-and-local-test.sh` will build the container image, and test it locally, 
similar(although not identical) to how it would be run from lambda.

Once the image is built you will have to push it to an ECR repo, and create your lambda function.
A lambda with 2GB of ram seems to work ok.

### Using SAM
A basic SAM template is included, with which you can deploy the lambda
```bash
# Build image
sam build
# Interactive deployment wizard
sam deploy --guided
```

## Things of note
If you want to save screenshots or video, you may need to run the project from the tmp dir, 
see the initial commit for an example of this.
