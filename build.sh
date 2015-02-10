#!/bin/bash -e
SOURCE_FILE=${NAME}${VERSION}.tar.bz2
module load ci
module add gcc/4.8.2

echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [[ ! -s $SRC_DIR/$SOURCE_FILE ]] ; then
  echo "seems like this is the first build - let's get the source"
  mkdir -p $SRC_DIR
  wget $URL/$VERSION/$SOURCE_FILE -O $SRC_DIR/$SOURCE_FILE
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi
ls -lht $SRC_DIR/$SOURCE_FILE
echo "extracting the tarball"
tar xzf $SRC_DIR/$SOURCE_FILE -C $WORKSPACE
echo "Going to $WORKSPACE/$NAME-$VERSION"
cd $WORKSPACE/$NAME-$VERSION
ls
./bootstrap --prefix=$SOFT_DIR
make
