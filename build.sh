gpg --keyserver pgp.mit.edu --recv-keys DD8203F5 || { echo "error fetching pgp key"; exit 1; }
expect -c "spawn gpg --edit-key DD8203F5 trust quit; expect \"Your decision? \" { send \"5\r\" }; expect \"Do you really want to set this key to ultimate trust? (y/N) \" { send \"y\r\" }; interact"
cp ~/.gnupg/pubring.gpg ~/.gnupg/trustedkeys.gpg

git clone https://github.com/panux/shpkg.git
mkdir build
export ROOTFS=$(pwd)/build
chmod 700 shpkg/shpkg.sh
shpkg/shpkg.sh bootstrap $(pwd)/shpkg

docker build -t panux/panux .
