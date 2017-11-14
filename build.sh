git clone https://github.com/panux/lpkg.git || exit 1
git -C lpkg checkout v0.10.7.3 || exit 1
mkdir meta-bin || exit 1
chmod 700 lpkg/alternative.sh || exit 1
ln -s $(pwd)/lpkg/alternative.sh $(pwd)/meta-bin/lpkg-alt || exit 1
bd=$PWD
(
export PATH=$PATH:$bd/meta-bin
cd lpkg || exit 1
make || exit 1
echo y | ./lpkg.sh bootstrap $bd/build-x86_64 dl.projectpanux.com beta x86_64 || exit 1
echo y | ./lpkg.sh bootstrap $bd/build-x86 dl.projectpanux.com beta x86 || exit 1
) || exit 1
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
