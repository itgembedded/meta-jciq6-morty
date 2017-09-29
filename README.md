# meta-jciq6-morty
Yocto Project for JCI Q6 Board - Morty Branch (v2.2.2)

Updated to include support for Chromium Browser v52 for the Q6 board
 
# Getting started with software for the Q6 Board
 
Here's some basic info about how to start with YOCTO and the Q6 Board. 
 
 
### 0) If upgrading from Krogoth, you may need to install these additional pkgs
    If upgrading your environment from Krogoth, Morty requires a few more host pkgs.
    If these are not already installed on your Host system, please install them as shown.

    sudo apt-get update
    sudo apt-get install linux-generic-lts-xenial
    sudo apt-get install python3-software-properties
    sudo apt-get install gcc-multilib socat
    sudo apt-get install cpio python python3 
    sudo apt-get install python3-pip python3-pexpect 

### 1) Install the repo utility
    mkdir ~/bin
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
 
### 2) Get the YOCTO project
    mkdir fsl-community-bsp
    cd fsl-community-bsp
    PATH=${PATH}:~/bin
    repo init -u https://github.com/Freescale/fsl-community-bsp-platform -b morty
 
### 3) Add Q6 support - create manifest 
    (still from fsl-community-bsp directory)
    mkdir -pv .repo/local_manifests/
 
    Copy and paste this into your Linux terminal to create your local repo manifest
 
    cat > .repo/local_manifests/Q6.xml << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <manifest>
     
      <remote fetch="git://github.com/itgembedded" name="itgembedded"/>
     
      <project remote="itgembedded" revision="morty" name="meta-jciq6-morty" path="sources/meta-jciq6">
          <copyfile src="jciq6-setup.sh" dest="jciq6-setup.sh"/>
      </project>

     <project remote="itgembedded" revision="morty" name="Q6-meta-browser" path="sources/meta-browser">
     </project>

    </manifest>
    EOF
 
### 4) Sync repositories
    repo sync
 
### 5) Add jciq6 and support meta layers into BSP
    source jciq6-setup.sh
 

# Building images
    cd .../fsl-community-bsp/
 
### Currently Supported machines <machine name>
    Here is a list of 'machine names' for Q6 images. Use the 'machine name' based on the board you have:
 
    jciq6  (for i.MX6Q)
    jciq6p (for i.MX6Q Plus)
     
### Setup and Build Console image
    Note: if moving from Krogoth, Morty now requires new DISTRO parameter

    MACHINE=<machine name> DISTRO=<distro name> source setup-environment build-dir
    bitbake <image>
 
    Example:
 
        MACHINE=jciq6 DISTRO=fslc-x11 source setup-environment build-jciq6
	(... make any desired changes to conf/local.conf now...)
        bitbake core-image-sato
 
### To include chromium in your image build
    These additions must be added AFTER executing setup-environment but BEFORE bitbake

    Include these lines in your local.conf:
        CORE_IMAGE_EXTRA_INSTALL += "chromium libexif"
        LICENSE_FLAGS_WHITELIST = "commercial"

    If Sato, or other desktop is included, Chromium desktop icon is installed.
    Frick Demo desktop icon is included to launch Chrome in kiosk mode, directly to Frick demo site.
    Otherwise, execute chromium via it's startup-script, passing params as needed: /usr/bin/google-chrome <params>

### To enlarge usable file system space in SD or CFAST card image
    By default, this build will add 30% extra "unused" space to the file system partition.

    You can increase usable file system space on your card image by setting these variables in local.conf:
        IMAGE_ROOTFS_SIZE = (total space allocated/formatted for partition, in KB)
	IMAGE_ROOTFS_EXTRA_SPACE = (in addition to required file space, in KB, default "0")
	IMAGE_OVERHEAD_FACTOR = (multiplier, defaults to "1.3")
	
    For example, to force slightly smaller that 4GB total rootfs partition size, add:
	IMAGE_ROOTFS_SIZE = "4000000"


# Creating SD card
    Output directories and file names depend on what you build. 
    The following example is based on running 'bitbake core-image-sato', using /dev/sdb, etc.
 
    sudo umount /dev/sdb2
    sudo umount /dev/sdb1
    sudo umount /dev/sdb
    gunzip -c ~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-sato-jciq6.sdcard.gz > ~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-sato-jciq6.sdcard
    sudo dd if=~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-sato-jciq6.sdcard of=/dev/sdb bs=1M conv=fdatasync
    sudo umount /dev/sdb2
    sudo umount /dev/sdb1
    sudo eject /dev/sdb
     
# Testing it on Q6 

To test your SD card, plug in the card and reset the Q6 board (press "Reset" button).

	1) U-Boot will load & execute from the base of the SD Card.
	2) U-Boot will load & execute optional boot script from SD partition 1 (boot_jciq6.scr)
	3) U-Boot will load kernel image (zImage) from SD partition 1
	4) U-Boot will load Device Tree (imx6q-jciq6.dtb) from SD partition 1
	5) Kernel now executes and loads rootfs from SD partition 2

