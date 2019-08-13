# ubuntuC_FLAGS="-C /usr/src/linux-headers-`uname -r`"
# opensuse
# C_FLAGS="-C /usr/src/linux-`uname -r`"
c_dir=`pwd`
for mf in `find $c_dir -type f -name "Makefile"`
do
    echo $mf
    cd `dirname $mf`
    make $C_FLAGS M=`pwd` modules
    mv *.ko $c_dir
    cd $c_dir 
done
