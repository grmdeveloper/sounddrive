# 原始出处#p_url='https://raw.githubusercontent.com/yangxiaohua1977/sound/master'
# 将要合并到kernel中的代码，使用这个仓库中的代码
p_url="https://raw.githubusercontent.com/dsd/linux/es8316"
files="
sound/soc/codecs/es8316.c
sound/soc/codecs/es8316.h
sound/soc/codecs/Makefile
sound/soc/codecs/Kconfig
sound/soc/intel/Kconfig
sound/soc/intel/boards/Makefile
sound/soc/intel/boards/cht_bsw_es8316.c
sound/soc/intel/boards/bytcht_es8316.c
sound/soc/intel/sst/atom/sst_acpi.c
sound/soc/intel/atom/sst/sst_acpi.c
sound/soc/intel/atom/sst-atom-controls.h
sound/soc/intel/common/sst-acpi.h
sound/soc/intel/common/sst-dsp.h
sound/soc/intel/atom/sst-mfld-platform.h
sound/soc/intel/atom/sst/sst.h
sound/soc/intel/atom/sst-mfld-dsp.h
"
for f in $files
do
    echo $f
    mkdir -p `dirname $f`
    wget $p_url/$f 
    mv `basename $f` $f 
done
