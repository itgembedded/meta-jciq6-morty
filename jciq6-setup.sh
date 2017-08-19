#!/bin/sh
 
LAYERS_DIR=./sources/base/conf/
LAYER_JCIQ6_STRING="BBLAYERS += \"\${BSPDIR}/sources/meta-jciq6\""
LAYER_BROWSER_STRING="BBLAYERS += \"\${BSPDIR}/sources/meta-browser\""
LAYER_GNOME_STRING="BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-gnome\""

if [ -w ${LAYERS_DIR}/bblayers.conf ]
then
    grep "${LAYER_GNOME_STRING}" "${LAYERS_DIR}/bblayers.conf" > /dev/null
    TMPRETVAL=$(echo $?)
    TMPPRINT=""
 
    if [ ${TMPRETVAL} -eq 0 ]
    then
        TMPPRINT="already present"
    fi
 
    if [ ${TMPRETVAL} -eq 1 ]
    then
        echo "${LAYER_GNOME_STRING}" >> ${LAYERS_DIR}/bblayers.conf
        TMPPRINT="added"
    fi
    echo "Layer meta-gnome ${TMPPRINT}"

    grep "${LAYER_BROWSER_STRING}" "${LAYERS_DIR}/bblayers.conf" > /dev/null
    TMPRETVAL=$(echo $?)
    TMPPRINT=""
 
    if [ ${TMPRETVAL} -eq 0 ]
    then
        TMPPRINT="already present"
    fi
 
    if [ ${TMPRETVAL} -eq 1 ]
    then
        echo "${LAYER_BROWSER_STRING}" >> ${LAYERS_DIR}/bblayers.conf
        TMPPRINT="added"
    fi
    echo "Layer meta-browser ${TMPPRINT}"

    grep "${LAYER_JCIQ6_STRING}" "${LAYERS_DIR}/bblayers.conf" > /dev/null
    TMPRETVAL=$(echo $?)
    TMPPRINT=""
 
    if [ ${TMPRETVAL} -eq 0 ]
    then
        TMPPRINT="already present"
    fi
 
    if [ ${TMPRETVAL} -eq 1 ]
    then
        echo "${LAYER_JCIQ6_STRING}" >> ${LAYERS_DIR}/bblayers.conf
        TMPPRINT="added"
    fi
    echo "Layer meta-jciq6 ${TMPPRINT}"

fi

