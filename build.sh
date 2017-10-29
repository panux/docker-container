git clone https://github.com/panux/lpkg.git
git -C lpkg checkout df435cfcacf7c0ee1ccfc8480cc9e8282f2b2665
echo $ROOTFS
chmod 700 lpkg/lpkg.lua
lua lpkg/lpkg.lua bootstrap "dl.projectpanux.com" beta x86 "$(pwd)/build-x86" || exit 1
lua lpkg/lpkg.lua bootstrap "dl.projectpanux.com" beta x86_64 "$(pwd)/build-x86_64" || exit 1
echo root:x:0:0:root:/root:/bin/sh > build-x86_64/etc/passwd
echo root::0:0:99999:7::: > build-x86_64/etc/shadow
echo root::0:root > build-x86_64/etc/group
echo root:x:0:0:root:/root:/bin/sh > build-x86/etc/passwd
echo root::0:0:99999:7::: > build-x86/etc/shadow
echo root::0:root > build-x86/etc/group

mv build-x86 build
docker build -t panux/panux:x86 . || exit 1
mv build build-x86

mv build-x86_64 build
docker build -t panux/panux:x86_64 . || exit 1
mv build build-x86_64
