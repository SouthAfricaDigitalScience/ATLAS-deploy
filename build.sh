#!/bin/bash -e
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}${VERSION}.tar.bz2
module load ci
module add gcc/${GCC_VERSION}
module add cmake
module add lapack/3.6.0-gcc-${GCC_VERSION}

# this is just to keep consistency with the other projects
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}

mkdir -p ${SRC_DIR}
mkdir -p ${SOFT_DIR}

#  Download the source file

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  mkdir -p $SRC_DIR
  wget http://downloads.sourceforge.net/project/math-atlas/Stable/${VERSION}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi
echo "extracting the tarball"
tar xfj ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}/${NAME}-${VERSION} --strip-components=1 --skip-old-files
echo "Going to ${WORKSPACE}/$NAME-$VERSION"
cd ${WORKSPACE}/${NAME}-${VERSION}
# ATLAS wants you to run configure from a different subdirectory
mkdir build-${BUILD_NUMBER}
cd build-${BUILD_NUMBER}
# for now we have hard-coded version numbers here for lapack
../configure --prefix=${SOFT_DIR}-gcc-${GCC_VERSION} --shared --with-netlib-lapack-tarfile=/repo/src/lapack/3.5.0/lapack-3.6.0.tar.gz
make
