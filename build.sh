#! /bin/bash
if [ -f .repo/repo ]; then
	echo "repo is already installed here"
else
	repo init -u https://github.com/CyanogenMod/android.git -b cm-13.0 -p linux
fi
if [ -f .repo/local_manifests/local_manifest.xml ]; then
	echo "local manifest already present"
else
	mkdir -p .repo/local_manifests/
	curl https://raw.githubusercontent.com/TeamRedux/local_manifests/cm-13.0-sprout/local_manifest.xml > .repo/local_manifests/local_manifest.xml
fi
repo sync -j16 --force-sync --no-tags --no-clone-bundle --no-repo-verify -f -c
. build/envsetup.sh
if [ $CLEAN ]; then
	make clean
else
	rm $OUT/*.zip
fi
# Fix for not using kernel source
mkdir -p $OUT/obj/KERNEL_OBJ/usr/include/

brunch $DEVICE
file=$(ls $OUT/cm-13.0-*.zip)
if [ -f $file ]; then
	cp $file $DIST
else
	echo "compile failed! fix the errors"
fi

