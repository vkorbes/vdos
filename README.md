# vdos

notes on msdos dev

# dosbox

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

# turbo c 2.01

- installer: `loot/tc201.zip`
- page: https://web.archive.org/web/20060516050946/http://community.borland.com/article/0,1410,20841,00.html
- download: https://web.archive.org/web/20060516050946/http://community.borland.com/article/images/20841/tc201.zip
- unzip all disks to the same folder
- `mount a [folder]`

# utils

edit.exe copied from freedos
exe2bin.com copied from freedos

ls.bat is `dir/w/p`

compile.bat:

```
rescan
tcc -ml %1
```

on bat files:
- dir & echo foo         # two commands
- dir && echo foo        # second only runs if first succeeds


# books

## advanced ms-dos, ray duncan

- masm 4
  - https://winworldpc.com/product/macro-assembler/4x
- msc 3
  - https://winworldpc.com/product/microsoft-c-c/3x

## advanced ms-dos, ray duncan 2nd ed

- masm 5.1
- 