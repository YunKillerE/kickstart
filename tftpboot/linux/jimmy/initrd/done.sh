#unzip xz initrd.img
#xz -dc initrd.img | cpio -id

#compress
find . | cpio -c -o | xz -9 --format=lzma > initrd.img
