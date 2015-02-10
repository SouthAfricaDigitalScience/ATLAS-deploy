module load ci
module add  gcc/4.8.2
module add cmake

NAME=`echo $NAME| tr '[:lower:]' '[:upper:]'`
cd $WORKSPACE/$NAME/MyObj
make check

echo $?
make check
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
setenv       ATLAS_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path LD_LIBRARY_PATH   $::env(ATLAS_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(GMP_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME
