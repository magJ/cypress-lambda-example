#!/bin/bash
set -euo pipefail

cypress_cache_dir=${CYPRESS_CACHE_FOLDER:="/opt/cypress"}

for cypress_version_dir in "$cypress_cache_dir"/*; do
  cypress_electron_binary_location="$cypress_version_dir/Cypress/Cypress"
  # Patches cypress's electron binary to replace references to /dev/shm to /tmp/shm, as /dev/shm isn't writable on lambda
  #
  # Alternatively setting ELECTRON_EXTRA_LAUNCH_ARGS="--no-zygote --disable-gpu --single-process", seems to be enough for
  # cypress to make it past initialisation, and start chromium, but it still seems to occasionally crash
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

