#!/bin/bash -e
. /etc/profile.d/modules.sh
module load deploy
module add  gcc/${GCC_VERSION}
module add cmake
module add lapack/3.5.0-gcc-${GCC_VERSION}

cd $WORKSPACE/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "cleaning previous build"
rm -rf *
../configure --prefix=${SOFT_DIR}-gcc-${GCC_VERSION} --shared --with-netlib-lapack-tarfile=/repo/src/lapack/3.5.0/lapack-3.5.0.tar.gz
make -j2

echo $?
make install
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module-whatis   "$NAME $VERSION."
# this could be done using toupper(name)
setenv       ATLAS_VERSION       $VERSION
setenv       ATLAS_DIR           $::env(CVMFS_DIR)$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-$::env(GCC_VERSION)

prepend-path LD_LIBRARY_PATH   $::env(ATLAS_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(ATLAS_DIR)/include
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES_MODULES}/${NAME}
