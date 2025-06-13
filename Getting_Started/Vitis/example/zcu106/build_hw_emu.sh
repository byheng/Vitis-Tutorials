mkdir hw_emu
cp xrt.ini hw_emu
cp run_hw_emu.sh hw_emu
cd hw_emu

$CXX -g -std=c++17 -Wall -O0 -fmessage-length=0 ../../src/host.cpp -o ./app.exe -I$SYSROOT/usr/include/xrt -LSYSROOT/usr/lib -lxrt_coreutil -pthread --sysroot=$SYSROOT
v++ -c -t hw_emu --platform zcu106_custom --config ../../src/zcu102.cfg -k vadd -I../../src ../../src/vadd.cpp -o ./vadd.xo 
v++ -l -t hw_emu --platform zcu106_custom --config ../../src/zcu102.cfg ./vadd.xo -o ./vadd.xclbin
v++ -p -t hw_emu --platform zcu106_custom --config ../../src/zcu102.cfg ./vadd.xclbin --package.out_dir ./package --package.rootfs ${ROOTFS}/rootfs.ext4 \
--package.sd_file ${ROOTFS}/Image --package.sd_file ./xrt.ini --package.sd_file ./app.exe --package.sd_file ./vadd.xclbin --package.sd_file ./run_hw_emu.sh