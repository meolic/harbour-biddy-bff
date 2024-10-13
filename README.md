# BFF

Boolean functions forever

A tool for minimization of Boolean functions.

## PUBLISH ON CHUM

1. Write changes in rpm/harbour-biddy-bff.changes
2. Remove file rpm/harbour-biddy-bff.spec
3. Adapt file rpm/harbour-biddy-bff.yaml
4. Build locally for target Sailfish OS Emulator, new rpm/harbour-biddy-bff.spec should be generated
5. Push to git, then check release number at https://github.com/meolic/harbour-biddy-bff/tree/main
6. Login to https://build.sailfishos.org/package/show/home:meolic/harbour-biddy-bff
7. Edit file _service in browser and update revision number. Save an the package should be regenerated, wait a little bit.
8. For new projects: click "Submit package" and submit to Target project "SailfishOS Chum"
9. For already accepted project: edit _service on https://build.sailfishos.org/package/show/sailfishos:chum/harbour-biddy-bff

## PUBLISH ON HARBOUR

 1. Publish on Chum to verify the package
 2. Clean locally for All Configurations
 3. Build locally for target armv7hl, Release, Build RPM Package For Manual Deployment (click Razmesti / Deploy)
 4. Build locally for target aarch64, Release, Build RPM Package For Manual Deployment (click Razmesti / Deploy)
 5. Sign in to https://harbour.jolla.com/dashboard
 6. Upload to Binaries
    /home/robert/SailfishOSProjects/build-biddy-bff-SailfishOS_4_5_0_18_armv7hl_in_Sailfish_SDK_Build_Engine-Release/RPMS
    /home/robert/SailfishOSProjects/build-biddy-bff-SailfishOS_4_5_0_18_aarch64_in_Sailfish_SDK_Build_Engine-Release/RPMS

## CHANGE SAILJAIL PERMISSIONS

Configuration for sailjail is given in file harbour-biddy-bff.desktop


## UPDATE BIDDY PACKAGE

cd ~/SailfishOSProjects/harbour-biddy-bff/src/biddy
./update-biddy.sh

## Sailfish OS OBS

- https://github.com/sailfishos-chum/main/blob/main/GettingStarted.md
- https://build.sailfishos.org/package/show/home:meolic/harbour-biddy-bff
- https://build.sailfishos.org/package/show/sailfishos:chum:testing/harbour-biddy-bff
- https://build.sailfishos.org/package/show/sailfishos:chum/harbour-biddy-bff
