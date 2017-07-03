packages=(basefs busybox musl libgpg-error libassuan libgcrypt zlib libintl gnupg shpkg)
repo="https://repo.projectpanux.com/beta"

gpg --keyserver pgp.mit.edu --recv-keys DD8203F5 || { echo "error fetching pgp key"; exit 1; }
expect -c "spawn gpg --edit-key DD8203F5 trust quit; expect \"Your decision? \" { send \"5\r\" }; expect \"Do you really want to set this key to ultimate trust? (y/N) \" { send \"y\r\" }; interact"
cp ~/.gnupg/pubring.gpg ~/.gnupg/trustedkeys.gpg

function fetchpackage() {
	wget $repo/pkgs/$pkg.tar.xz -O packages/$pkg.tar.xz
	wget $repo/pkgs/$pkg.sig -O packages/$pkg.sig
	gpgv packages/$pkg.sig packages/$pkg.tar.xz || { echo "verification error"; exit 1; }
}

function extractpackage() {
	tar -xf packages/$1.tar.xz --exclude ./.pkginfo -C build
}

function runonall() {
	for pkg in "${packages[@]}"; do
		$1 $pkg
	done
	wait
}

function cleanup() {
	rm -f *.tar.xz
	rm -rf build
	rm -rf packages
}

trap cleanup EXIT
mkdir build packages

echo Packages:
runonall 'echo -e \t'
runonall fetchpackage
runonall extractpackage

printf "%s\n" "${packages[@]}" > build/etc/shpkg/pkgs.list

docker build -t panux/panux .
