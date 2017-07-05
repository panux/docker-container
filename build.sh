gpg --keyserver pgp.mit.edu --recv-keys DD8203F5 || { echo "error fetching pgp key"; exit 1; }
expect -c "spawn gpg --edit-key DD8203F5 trust quit; expect \"Your decision? \" { send \"5\r\" }; expect \"Do you really want to set this key to ultimate trust? (y/N) \" { send \"y\r\" }; interact"
cp ~/.gnupg/pubring.gpg ~/.gnupg/trustedkeys.gpg

git clone https://github.com/panux/lpkg.git
mkdir build
echo $ROOTFS
chmod 700 lpkg/lpkg.sh
lpkg/lpkg.lua bootstrap $(pwd)/build https://repo.projectpanux.com/beta/pkgs/

docker build -t panux/panux .
