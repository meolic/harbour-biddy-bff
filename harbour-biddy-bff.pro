# ADD/REMOVE BUILDING FOR VARIOUS KITS
#
# Menu "Projects" -> Build and Run
#
# DEPLOY AND START IN EMULATOR ON LINUX
#
# Kit: SailfishOS-4.1.0.24-i486 (in Sailfish OS Build Engine)
# Build: Debug
# Deploy: Deploy By Copying Binaries (this will enable debug strings)
#
# CHANGE THE EMULATOR MODE
#
# Manage -> Sailfish OS -> Emulator -> button "Emulator mode..." (NOT menu "Emulator mode")
#
# DEPLOY ON XPERIA XA2 (this is 32-bit architecture)
#
# Kit: armv7hl
# Build: Release
# Deploy: Deploy As RPM Package
#
# DEPLOY ON SONY XPERIA 10 III (this is 64-bit architecture)
#
# Kit: aarch64
# Build: Release
# Deploy: Deploy As RPM Package
#
# TO CHANGE THE NAME:
#
# Application name defined in TARGET has a lot of corresponding filenames.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - change filename of this file (*.pro) and check/adapt all the content
#   - change *.desktop filename and its content
#   - desktop icons filename must be changed (Other files -> icons -> *.png)
#   - all files in subfolders containing different resolutions of icons must be changed
#   - rpm filenames must be changed (Other files -> rpm -> *.spec *.yaml *.in)
#   - content of *.spec, *.yaml, and *.in file must be changed
#   - translation filenames have to be changed
#
#
# CHANGE SAILJAIL PERMISSIONS
#
# Configuration for sailjail is given in file harbour-biddy-bff.desktop
#
# UPDATE BIDDY PACKAGE
#
# cd ~/SailfishOSProjects/harbour-biddy-bff/src/biddy
# ./update-biddy.sh

# The name of your application
TARGET = harbour-biddy-bff

CONFIG += sailfishapp

HEADERS += \
    biddy/biddy.h \
    biddy/biddyInt.h \
    src/booleanfunction.h \
    src/quinemccluskey.h \
    src/truthtablemodel.h \
    src/implicantcirclemodel.h \
    src/karnaughmapmodel.h \
    src/coveringtablemodel.h

SOURCES += \
    biddy/biddyInOut.c \
    biddy/biddyMain.c \
    biddy/biddyOp.c \
    biddy/biddyStat.c \
    src/main.cpp \
    src/booleanfunction.cpp \
    src/quinemccluskey.cpp \
    src/truthtablemodel.cpp \
    src/implicantcirclemodel.cpp \
    src/karnaughmapmodel.cpp \
    src/coveringtablemodel.cpp

DISTFILES += \
    _service \
    biddy/update-biddy.sh \
    harbour-biddy-bff.desktop \
    biddy/update-biddy.sh \
    icons/harbour-biddy-bff.png \
    rpm/harbour-biddy-bff.changes \
    rpm/harbour-biddy-bff.spec \
    rpm/harbour-biddy-bff.yaml \
    translations/*.ts \
    qml/cover/CoverPage.qml \
    qml/Main.qml \
    qml/KarnaughMap.qml \
    qml/TruthTable.qml \
    qml/SOP.qml \
    qml/QM.qml \
    qml/About.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256 480x480 560x560

# NICE TO HAVE BUT IS SEEMS TO BE UNSUPPORTED FROM JOLLA

#unix|win32: LIBS += -lgmp

# OTHERS THAT MAY BE USEFUL

#CONFIG += console
QT_LOGGING_RULES = "*.debug=false;qml=false"

# TRANSLATIONS

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/harbour-biddy-bff-de.ts
