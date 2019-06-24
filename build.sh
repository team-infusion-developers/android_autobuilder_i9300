#! /bin/bash

#
# The Invincible Team for deprecated phones!
#
# Team InFusion
#
# Copyright 2018 Team InFusion
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


TEAM_NAME="Team InFusion"
TARGET=i9300
LOS_VER=16.0
VERSION_BRANCH=lineage-16.0
OUT="out/target/product/i9300"
ROM_VERSION=2.0
export LINEAGEOS_VERSION=$ROM_VERSION
export ANDROID_HOME=~/Android/Sdk

buildTest()
{
	export z=`date "+%H%M%S-%d%m%y"`
	echo "Building..."
	time schedtool -B -n 1 -e ionice -n 1 make otapackage -j10 "$@"
	if [ "$?" == 0 ]; then
		echo "Build done"
		mv $OUT/lineage*.zip $OUT/Optimized_lineage-16.0-V$ROM_VERSION-$z.zip 
	else
		echo "Build failed"
	fi
	croot
}
buildRelease()
{
	echo "Building..."
	time schedtool -B -n 1 -e ionice -n 1 make otapackage -j10 "$@"
	if [ "$?" == 0 ]; then
		echo "Build done"
		mv $OUT/lineage*.zip $OUT/Optimized_LineageOS-$LOS_VER-Version-$ROM_VERSION.zip 
	else
		echo "Build failed"
	fi
	croot
}

anythingElse() {
    echo " "
    echo " "
    echo "Anything else?"
    select more in "Yes" "No"; do
        case $more in
            Yes ) bash build.sh; break;;
            No ) exit 0; break;;
        esac
    done ;
}


upstreamMerge() {

	croot
	#echo "Cloning LineageOS Sources"
	#repo init -u git://github.com/LineageOS/android.git -b "$VERSION_BRANCH"
	#echo "Cloning Team Infusion Sources"
	# git clone git://github.com/team-infusion-developers/android_local_manifests_i9300 .repo/local_manifests -b "$VERSION_BRANCH"
	#echo "Syncing projects"
	#repo sync --no-tags --no-clone-bundle --force-sync -c -j8
	
       
       
}




}
createRemotes () 
{
	croot
	#vendor/samsung/i9300
	cd vendor/samsung/i9300
	git remote remove origin
	git remote add origin git@github.com:team-infusion-developers/android_vendor_samsung_i9300.git
	croot
	#vendor/samsung/smdk4412-common
	cd vendor/samsung/smdk4412-common
	git remote remove origin
	git remote add origin git@github.com:team-infusion-developers/android_vendor_samsung_smdk4412-common.git
	croot
	#device/samsung/i9300
	cd device/samsung/i9300
	git remote remove origin
	git remote add origin git@github.com:team-infusion-developers/android_device_samsung_i9300.git
	croot
	#hw/samsung
	cd hardware/samsung
	git remote remove origin
	git remote add origin git@github.com:team-infusion-developers/android_hardware_samsung.git
	croot
	# kernel
	cd kernel/samsung/smdk4412
	git remote remove origin
	git remote add origin git@github.com:team-infusion-developers/android_kernel_samsung_smdk4412.git
	croot
	
}


echo " "
echo -e "\e[1;91mWelcome to the $TEAM_NAME build script"
echo -e "\e[0m "
echo "Generate keys used for ROM signing,From the root of your Android tree, run these commands, altering the subject line to reflect your information"

subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'
mkdir .android-certs
for x in releasekey platform shared media testkey; do \
    ./development/tools/make_key .android-certs/$x "$subject"; \
done

echo "Setting up build environment..."
. build/envsetup.sh > /dev/null
echo "Setting build target $TARGET""..."
lunch lineage_"$TARGET"-userdebug > /dev/null
echo "fasten up build process"
make -j8 bacon
echo " "
echo -e "\e[1;91mPlease make your selections carefully"
echo -e "\e[0m "
echo " "
done
exit 0
