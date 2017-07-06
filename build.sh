gpg --keyserver keys.gnupg.net --recv-keys DD8203F5 || { echo "error fetching pgp key"; exit 1; }
expect -c "spawn gpg --edit-key DD8203F5 trust quit; expect \"Your decision? \" { send \"5\r\" }; expect \"Do you really want to set this key to ultimate trust? (y/N) \" { send \"y\r\" }; interact"
cp ~/.gnupg/pubring.gpg ~/.gnupg/trustedkeys.gpg

git clone https://github.com/panux/lpkg.git
mkdir build-x86 build-x86_64
echo $ROOTFS
chmod 700 lpkg/lpkg.sh
lpkg/lpkg.lua bootstrap $(pwd)/build-x86 https://repo.projectpanux.com/beta/x86/pkgs/
lpkg/lpkg.lua bootstrap $(pwd)/build-x86_64 https://repo.projectpanux.com/beta/x86_64/pkgs/

mv build-x86 build
docker build -t panux/panux:x86 .
mv build build-x86
mv build-x86_64 build
docker build -t panux/panux:x86_64 .
mv build build-x86_64
