Import stripped Snapdragon LLVM ARM Compiler 14.1.2

- Strip binaries to optimize size (thanks Ju Hyung Park)
- Restore symlinks to reduce I/O (thanks Ju Hyung Park)
- Make LLD binaries executable to fix build errors

Strip binaries:

find . -type f -exec file {} \; \
    | grep "x86" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do
            strip $file
done

find . -type f -exec file {} \; \
    | grep "ARM" \
    | grep "aarch64" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do aarch64-linux-android-strip $file
done

find . -type f -exec file {} \; \
    | grep "ARM" \
    | grep "32.bit" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do arm-linux-androideabi-strip $file
done

Restore symlinks:

find * -type f -size +1M -exec xxhsum {} + > list
awk '{print $1}' list | uniq -c | sort -g
rm list

Make LLD binaries executable:

chmod a+x bin/ld*