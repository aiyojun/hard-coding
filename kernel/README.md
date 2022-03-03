# kernel compilation

内核编译记录

## arm64/aarch64架构的交叉编译

### toolchain

使用arch linux源自带的aarch64-linux-gnu-gcc系列

### 内核源码

均是5.7版本的最新内核

- linux官方源码即可
- android官方源码也可

### 编译命令及说明

```shell
### 提前说明一下：不管什么平台或架构，都是需要进行内核及模块配置的，且需要按照对应的底层架构和平台来进行配置，
### 一般平台会提供配置文件在内核源码里面，都是以defconfig结尾，存在与arch/*/config/目录下。
### 一般而言是不需要自己进行配置的，除非你对内核及模块非常了解。

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig      # 使用默认arm64的配置
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j12 Image.gz  # 编译生成gz压缩版本的内核
### 这里说明一下，也可以生成Image未压缩版本内核
### 编译完成后，Image.gz存在于arch/arm64/boot/路径下

### 使用qemu进行模拟运行
qemu-system-aarch64 -m 8G -machine virt -cpu cortex-a57 -kernel arch/arm64/boot/Image.gz --append "console=ttyAMA0"
### 注意：这里一定要加上console=ttyAMA0,否则串口无法输出日志内容。

```

### 编译x86内核

```shell
### 使用系统自带gcc即可
make x86_64_defconfig
make -j12 bzImage      # 生成bz压缩版本的内核，qemu所支持的内核类型
### 若不确定makefile的编译目标，可以使用make help命令查看
### make all 一般是编译所有内容，包括内核，驱动等
### bzImage一般生成到arch/x86/boot/路径下面
### vmlinux版本一般生成在内核源码的根目录下
### 注意：vmlinux版本内核，qemu是无法识别的！

### qemu运行x86镜像
qemu-system-x86_64 -kernel arch/x86/boot/bzImage
### 上述命令，会将printk日志内容输出到vga显示器上(25行*80列空间)
qemu-system-x86_64 -kernel arch/x86/boot/bzImage --append "console=ttyS0,9600"
### 该命令，会将printk日志输出到serial串口上。
### 波特率，115200也可，主要是qemu只要你设置了就行。

```


### 交叉编译busybox

```shell
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j12
make install
### 请直接make install,无需担心生成的文件会dump到系统的/usr环境
### 生成的所有文件都在_install路径下

### x86版本的busybox编译，直接编译即可
make -j12
make install

```

### initrd制作

```shell
### 编译完成busybox后，需要将/usr/aarch64-linux-gnu的动态库移植过来，busybox依赖这些。
### 主要依赖有ld-linux-aarch64.so.1 libc.so.6 libm.so.6 libresolv.so
### 注意软链接和本体的关系
mkdir _install/lib
mkdir _install/lib/aarch64-linux-gnu
cp /usr/aarch64-linux-gnu/lib/ld-* _install/lib
cp /usr/aarch64-linux-gnu/lib/libc-* _install/lib
cp /usr/aarch64-linux-gnu/lib/libc.so* _install/lib
cp /usr/aarch64-linux-gnu/lib/libm-* _install/lib
cp /usr/aarch64-linux-gnu/lib/libm.so* _install/lib
cp /usr/aarch64-linux-gnu/lib/libresolv-* _install/lib
cp /usr/aarch64-linux-gnu/lib/libresolv.so* _install/lib
cd _install/lib/aarch64-linux-gnu
ln -s ../libc-* libc.so.0
ln -s ../libc-* libc.so.6
ln -s ../libm-* libm.so.0
ln -s ../libm-* libm.so.6
ln -s ../libresolv-* libresolv.so
ln -s ../ld-linux-aarch64.so.1 ld-linux-aarch64.so.1
cd ../../
### --------------------------------
### 接下来，编写init脚本
### 最简单的脚本:
### #!/bin/sh
###   /bin/sh
### --------------------------------
### 确保上述移植没有问题，再进行下面的操作
### --------------------------------
cd _install
find . | cpio -o -H newc | gzip -c >../initrd-aarch64.img
### 注意cpio生成格式，和gzip生成initrd的最终路径。

```

### busybox的使用

busybox编译生成的所有文件，本质上只有一个二进制文件/bin/busybox，其他内容均是软链接，但是busybox会根据命令路径来判断是那个命令被使用了。

你需要自己编写一个init脚本来完成所有的杂项任务，如卸载initrd(初始rootfs)，挂载新的根文件系统，启动主系统的init进程。

### FAQ

1. 编译出现头文件错误大多是gcc本身版本的问题，最好的方法是使用一个最新无污染的gcc环境来进行编译。

2. 一定要确保Makefile里面的CC,CXX,HOSTCC,HOSTCXX这些环境变量的准确性，’HOST-‘的变量是指本地x86版本的gcc系列工具。大多数情况是CC和CROSS_COMPILE变量未配好，在Makefile里面增加一个target任务，并echo出来这些变量进行调试即可。

3. 其他交叉编译的项目，configure系列的编译工具使用:

```shell
mkdir build && cd build && ../configure --prefix $INSTALL_PATH --host=aarch64-linux-gnu --build=x86-linux-gnu
### 注意区分：
### host:  指编译出来的二进制程序所执行的主机
### build: 执行代码编译的主机，也就是当前主机
### target:暂未用到

### 目前，使用configure工具编译过的项目有:
### 1. python-3.9.0
### 2. glibc-2.34.0  # 2.35编译代码有错误

```

4. 重新编译，或者之前出现编译出错的，都需要make clean清理一下。make mrproper可以清理所有。

5. 图形化的makefile配置命令是make menuconfig，用以生成配置文件，但大部分情况是不需要这么做的，在你看了上述内容之后。

6. 以makefile menuconfig构建项目的，目前就只发现linux kernel和busybox，当然，后期还会使用uboot之类的bootloader项目。

