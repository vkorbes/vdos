> If I had a time machine that could send source code back in time, and I sent it to a competant developer 20 years ago, would they be able to compile it and run it? If the answer is yes, then that means it  already has 20 years of future-proofing built into it.

# vDOS

V's notes on MS-DOS programming.

# DOSBox Setup

install (not tested): `brew install dosbox`

to generate config file: `config -writeconf file.conf`

fn+f10 unlocks mouse!

changes:

```
fullresolution=desktop
aspect=true
autolock=false
...
mount c ~/code/vdos/
c:
```

run with: `/Applications/dosbox.app/Contents/MacOS/DOSBox -conf DOSBox.conf`

can pass commands at start e.g.: `./run.sh -c "mount a floppies/tc201"`

# QEMU Setup

- [MS-DOS 6.22 (WinWorld)](https://winworldpc.com/product/ms-dos/622)
- [Installing MS-DOS on Qemu](https://gunkies.org/wiki/Installing_MS-DOS_on_Qemu)
- [How To Change The Floppy Image Of Qemu?](https://superuser.com/questions/97491/how-to-change-the-floppy-image-of-qemu)
- Start with: `qemu-system-i386 -hda msdos.disk -m 64 -soundhw sb16,adlib,pcspk
`

Read this later for network: https://virtuallyfun.com/wordpress/category/install/
And shared drives: https://superuser.com/questions/1630317/how-to-transfer-files-from-host-to-dos-qemu-c-drive

# turbo c 2.01

- installer: `loot/tc201.zip`
- page: https://web.archive.org/web/20060516050946/http://community.borland.com/article/0,1410,20841,00.html
- download: https://web.archive.org/web/20060516050946/http://community.borland.com/article/images/20841/tc201.zip
- unzip all disks to the same folder
- `mount a [folder]`

# utils

edit.exe copied from freedos
exe2bin.com copied from freedos
debug.com copied from freedos

ls.bat is `dir/w/p`

compile.bat:

```
rescan
tcc -ml %1
```

on bat files:
- dir & echo foo         # two commands
- dir && echo foo        # second only runs if first succeeds


# Books

## Assembly Primer for the IBM PC & XT

See README.md in `data/assembly-primer-ibm-pc/`.

## advanced ms-dos, ray duncan

- masm 4
  - https://winworldpc.com/product/macro-assembler/4x
- msc 3
  - https://winworldpc.com/product/microsoft-c-c/3x

## advanced ms-dos, ray duncan 2nd ed

- masm 5.1

## Assembly Language Step-by-Step: Programming with DOS and Linux, Second Edition

- http://www.staroceans.org/kernel-and-driver/Assembly%20Language%20Step-by-Step%20Programming%20with%20DOS%20and%20Linux%202nd.pdf

## Programming with 64-Bit ARM Assembly Language

- mac version: https://smist08.wordpress.com/2021/01/08/apple-m1-assembly-language-hello-world/
- An introduction to ARM64 assembly on Apple Silicon Macs: https://github.com/below/HelloSilicon

# links

- https://project-awesome.org/balintkissdev/awesome-dos
- Microsoft KnowledgeBase Archive: https://github.com/jeffpar/kbarchive

## old software

- winworld: https://winworldpc.com
- vetusware: https://vetusware.com
- phatcode, books and tools: http://www.phatcode.net
- doshaven: http://www.doshaven.eu/programming-tools/

## emulators

- pcjs: https://www.pcjs.org | https://github.com/jeffpar/pcjs
- DOS emulator for 68k: http://macintoshgarden.org/apps/softpc-31
- dosbox: https://www.dosbox.com/
- 8086tiny: https://github.com/adriancable/8086tiny
- Emulating Windows XP x86 under M1 Mac via UTM & QEMU: https://tinyapps.org/blog/202105220715_m1_mac_emulate_x86.html

## assembly

- zen of assembly: https://github.com/jagregory/abrash-zen-of-asm
- [!] The Art of ASSEMBLY LANGUAGE PROGRAMMING: http://www.phatcode.net/res/223/files/html/toc.html
- masm 6.1 manual: https://www.mikrocontroller.net/attachment/450367/MASM61PROGUIDE.pdf
- dos coding with watcom: http://nuclear.mutantstargoat.com/articles/retrocoding/dos01-setup/
- some code dos in virtualbox in macos: https://github.com/skissane/dos-assembly
- assembly language step by step
  - 2nd edition, DOS and linux: http://www.staroceans.org/kernel-and-driver/Assembly%20Language%20Step-by-Step%20Programming%20with%20DOS%20and%20Linux%2C%202ed%20(Wiley%2C%202000).pdf
  - 3rd edition, linux: http://www.staroceans.org/kernel-and-driver/Assembly%20Language%20Step-By-Step%20-%20Programming%20with%20Linux%2C%203rd%20edition%20(Wiley%2C%202009%2C%200470497025).pdf
  - boot our own kernels on Apple Silicon https://www.youtube.com/watch?app=desktop&v=d5s9fYfvzmY&t=12260s
  - How a Go Program Compiles down to Machine Code: https://getstream.io/blog/how-a-go-program-compiles-down-to-machine-code/

- x86 and amd64 instruction reference: https://www.felixcloutier.com/x86/index.html

- x86 is an octal machine: https://gist.github.com/seanjensengrey/f971c20d05d4d0efc0781f2f3c0353da 
  - extra links: https://news.ycombinator.com/item?id=30409100

## arm64

 - ARM64 Assembly Speedrun: https://dev.to/taw/100-languages-speedrun-episode-46-arm64-assembly-1lfk
  - The AArch64 processor (aka arm64), part 1: Introduction: https://devblogs.microsoft.com/oldnewthing/20220726-00/?p=106898
  

## msdos

- msdos 6 user guide: https://archive.org/details/microsoft-ms-dos-6/page/n3/mode/2up
- freedos embedded with qemu: https://opensource.com/article/21/6/freedos-embedded-system
- qemu dos docker: https://github.com/jgoerzen/docker-qemu-dos
- source code: https://github.com/microsoft/MS-DOS
- ibm bios source code: https://pcdosretro.github.io
- [MS-DOS 6.22 Bootable ISO](https://archive.org/details/ms-dos-6.22_dvd) (Didn't work for QEMU!)



## raycasting project

- lodev raycasting: https://lodev.org/cgtutor/raycasting.html
- golang sdl2: https://github.com/veandco/go-sdl2-examples/blob/29a79b36df6da7ecbcb99360a99f9e71a3cf6413/examples/render/render.go
- c sdl2: https://www.udemy.com/course/creating-a-chip-8-emulator-in-c/learn/lecture/18290062?start=0#overview
- peterhellberg port: 
  - https://github.com/peterhellberg/pixel-experiments/blob/master/raycaster/raycaster-untextured.go
  - https://gist.github.com/peterhellberg/835eccabf95800555120cc8f0c9e16c2

## graphics programming

- [!] brackeen vga programming in c: http://www.brackeen.com/vga/

## wasm

- wasm gfx: http://cliffle.com/blog/bare-metal-wasm/
- wasm go: https://blog.suborbital.dev/foundations-wasm-in-golang-is-fantastic
- rust wasm 3d: https://www.youtube.com/watch?v=p7DtoeuDT5Y

## windows

- win98 dev with qemu: https://nullprogram.com/blog/2018/04/13/
  - installer: https://archive.org/details/win98se_201607 (need serial)
  - borland c++ 5.02: https://archive.org/details/BorlandC5.02
- Portable C and C++ Development Kit for x64 Windows: https://github.com/skeeto/w64devkit
- A guide to Windows application development using w64devkit: https://nullprogram.com/blog/2021/03/11/
- How To Run Any Windows CLI App in a Linux Docker Container: https://betterprogramming.pub/how-to-run-any-windows-cli-app-in-a-linux-docker-container-318cd49bdd25

- 3.11 online
  - Connecting to the WWW With Windows for Workgroups 3.11 https://christianliebel.com/2016/06/connecting-internet-windows-workgroups-3-11/
  - Browsing the Internet on a 1993 Windows 3.11 All-In-One PC https://www.linuxscrew.com/raspberry-pi-web-rendering-proxy
  - BUILDING A NEW WIN 3.1 APP IN 2019 PART 1: SLACK CLIENT https://yeokhengmeng.com/2019/12/building-a-new-win-3-1-app-in-2019-part-1-slack-client/

## c

- beej's guide to c: https://beej.us/guide/bgc/

## games

- tfx combat flight simulator: https://en.wikipedia.org/wiki/TFX_(video_game)
- dosgames listing 3d games: https://dosgames.com/listing.php?sortby=ratingdesc&sterms2=&cat=3d-shooting&tag=&license=all&year=all&filesize=all&developer=all&publisher=all
- What were the best 3d polygon graphics in a dos game? (reddit): https://www.reddit.com/r/dosgaming/comments/f5fsuy/comment/fhzi0up/?utm_source=reddit&utm_medium=web2x&context=3





######################################################

dosbox change color: https://stackoverflow.com/questions/36219498/change-the-background-color-of-dosbox-console-when-executing-a-tasm-program