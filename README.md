#PySPIM

##Python version

3.4.2

#目录结构

仅介绍重要文件和文件夹

## pyspim.py

虚拟机主体模块和 REPL

## external_device.py

基于 Pygame 实现的外部设备模块

## mipscode

mips 源代码文件夹，其中文件以 `.s` 结尾

## machinecode

机器码文件夹，与 `mipscode` 中的文件一一对应，由编译器生成，以 `.bin`结尾

## assembler

汇编器工程目录，相对独立

#使用方法

##1. 编译机器码

首先将写好的 mips 代码文件 source.s 放入 mipscode 文件夹

在工程目录下执行 `python asm.py source.s`

在 machinecode 文件夹中会生成 source.bin

##2. 运行虚拟机

在工程目录下执行 `python pyspim.py machinecode/source.bin`

- r: run，直接执行（执行后需要使用 ctrl + c 退出）
- s: step, 单步执行
- p: peek，查看虚拟机状态
- e: exit，退出虚拟机（仅在非run状态下）
- t: test，单步执行固定步数，是对 run 的短暂模拟
