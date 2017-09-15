git clone https://github.com/panux/lpkg.git
echo $ROOTFS
chmod 700 lpkg/lpkg.lua
#lpkg/lpkg.lua bootstrap $(pwd)/build-x86 https://repo.projectpanux.com/beta/x86/pkgs/
lua lpkg/lpkg.lua bootstrap "repo.projectpanux.com" beta x86_64 "$(pwd)/build-x86_64" || exit 1
echo root:x:0:0:root:/root:/bin/sh > build-x86_64/etc/passwd
echo root::0:0:99999:7::: > build-x86_64/etc/shadow
echo root::0:root > build-x86_64/etc/group

#mv build-x86 build
#docker build -t panux/panux:x86 .
#mv build build-x86

mv build-x86_64 build
docker build -t panux/panux:x86_64 .
mv build build-x86_64
