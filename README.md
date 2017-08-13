# meta-Q6
Yocto Project for JCI Q6 Board - Morty Branch
 
# Getting started with software for the Q6 Board
 
Here's some basic info about how to start with YOCTO and the Q6 Board. 
 
  
### 1) Install the repo utility
    mkdir ~/bin
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
 
### 2) Get the YOCTO project
    cd
    mkdir fsl-community-bsp
    cd fsl-community-bsp
    PATH=${PATH}:~/bin
    repo init -u https://github.com/Freescale/fsl-community-bsp-platform -b morty
 
### 3) Add Q6 support - create manifest 
    cd ~/fsl-community-bsp/
    mkdir -pv .repo/local_manifests/
 
Copy and paste this into your Linux host machine 
 
    cat > .repo/local_manifests/Q6.xml << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <manifest>
     
      <remote fetch="git://github.com/itgembedded" name="itgembedded"/>
     
      <project remote="itgembedded" revision="morty" name="meta-jciq6-morty" path="sources/meta-jciq6">
        <copyfile src="jciq6-setup.sh" dest="jciq6-setup.sh"/>
      </project>
    </manifest>
    EOF
 
### 4) Sync repositories
    repo sync
 
### 5) Add Q6 meta layer into BSP
    source jciq6-setup.sh
 
# Building images
    cd ~/fsl-community-bsp/
 
### Currently Supported machines <machine name>
Here is a list of 'machine names' for Q6 images. Use the 'machine name' based on the board you have:
 
    jciq6
     
### Setup and Build Console image
    MACHINE=<machine name> DISTRO=<distro name> source setup-environment build-dir
    bitbake <image>
 
Example:
 
 
    MACHINE=jciq6 DISTRO=fslc-x11 source setup-environment build-jciq6
    bitbake core-image-sato
 

# Creating SD card
Output directories and file names depend on what you build. Following example is based on running 'bitbake core-image-base':
 
 
    umount /dev/sdb?
    gunzip -c ~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-base-jciq6.sdcard.gz > ~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-base-jciq6.sdcard
    sudo dd if=~/fsl-community-bsp/build-Q6/tmp/deploy/images/jciq6/core-image-base-jciq6.sdcard of=/dev/sdb bs=1M && sync
    umount /dev/sdb?
     
# Testing it on Q6 

To test your SD card, plug in the card and reset the Q6 board (press "Reset" button).  

	1) U-Boot will load & execute from the base of the SD Card.
	2) U-Boot will load & execute optional boot script from SD partition 1 (boot_jciq6.scr)
	3) U-Boot will load kernel image (zImage) from SD partition 1
	4) U-Boot will load Device Tree (imx6q-jciq6.dtb) from SD partition 1
	5) Kernel now executes and loads rootfs from SD partition 2

