#!/bin/bash
set -euo pipefail

cypress_cache_dir=${CYPRESS_CACHE_FOLDER:="/opt/cypress"}

for cypress_version_dir in "$cypress_cache_dir"/*; do
  cypress_electron_binary_location="$cypress_version_dir/Cypress/Cypress"
  # Patches cypress's electron binary to replace references to /dev/shm to /tmp/shm, as /dev/shm isn't writable on lambda
  #
  # If this is too hacky for you, and you want to use another browser like chromium.
  # You will need still to set ELECTRON_EXTRA_LAUNCH_ARGS="--no-zygote --disable-gpu --single-process"
  # Because electron is still invoked in the cypress initialization process, regardless of if you intent to use it or not
  # The above environment variables will be enough for the electron initialization to proceed, and avoid the need to patch
  position=$(strings -t d $cypress_electron_binary_location | grep "/dev/shm" | cut -d" " -f1)
  for i in $position; do
    echo -n "/tmp/shm/" | dd bs=1 of=$cypress_electron_binary_location seek="$i" conv=notrunc
  done

  # Patch `checkAccess` to not crash on EROFS,
  # without this patch you need to copy your cypress project dir to a writeable location
  # ie, /tmp/cypress-project you may want to do this if you want to upload saved screenshots or videos
  # There is a PR to upstream this patch https://github.com/cypress-io/cypress/pull/24253 which may make this unnecessary
  sed -i "s/\['EACCES', 'EPERM'\]/['EACCES', 'EPERM', 'EROFS']/" "$cypress_version_dir/Cypress/resources/app/packages/server/lib/modes/run.js"
done

