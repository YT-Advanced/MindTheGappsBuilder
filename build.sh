#!/bin/bash
# (c) Joey Rizzoli, 2015
# (c) Paul Keith, 2017
# Released under GPL v2 License

DATE=$(date -u +%Y%m%d)
TOP=$(realpath .)
ANDROIDV=13.0.0
GARCH=$1
OUT=$TOP/out
COMMON=$TOP/common/proprietary
PREBUILT=$TOP/$GARCH/proprietary
BUILDZIP=MindTheGapps-$ANDROIDV-$GARCH-$DATE
CREATED=$OUT/$GARCH/system

# Copy files
echo "Starting GApps compilation"
echo "ARCH= $GARCH"
mkdir $OUT
mkdir -p $OUT/$GARCH
mkdir -p $CREATED
echo -e "\nCopying prebuilts..."
cp -r $PREBUILT/* $CREATED
cp -r $COMMON/* $CREATED

# Remove files don't used with WSA
echo -e "\nRemoving files..."
cd $CREATED
rm -rfv product/{app,framework,lib}/
rm -rfv product/etc/default-permissions/default-permissions-mtg.xml
rm -rfv product/etc/permissions/com.google.android.dialer.support.xml
rm -rfv product/etc/sysconfig/{d2d_cable_migration_feature,google_build}.xml
rm -rfv product/priv-app/{AndroidAutoStub,GoogleRestore}
rm -rfv system_ext/priv-app/GoogleFeedback/

# Copy additional files
echo -e "\nCopying fixing files..."
cd $TOP
cd ../
cp -frav system/* $CREATED

# Compress
echo -e "\nCreating package..."
cd $OUT/$GARCH
find system -exec touch -amt 200901010000.00 {} \;
zip -r $OUT/$BUILDZIP system
rm -rf system
cd $TOP

echo -e "\nDone!"
echo "Build completed"
exit 0
