packages=(basefs busybox musl libgpg-error libassuan libgcrypt zlib libintl gnupg shpkg)
repo="https://repo.projectpanux.com/beta"

gpg --keyserver pgp.mit.edu --recv-keys DD8203F5 || { echo "error fetching pgp key"; exit 1; }

function fetchpackage() {
	wget $repo/pkgs/$pkg.tar.xz -O packages/$pkg.tar.xz
	wget $repo/pkgs/$pkg.sig -O packages/$pkg.sig
	gpg2 --verify packages/$pkg.sig packages/$pkg.tar.xz || { echo "verification error"; exit 1; }
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
mkdir build
mkdir packages

echo Packages:
runonall 'echo -e \t'
echo Downloading and verifying packages. . .
runonall fetchpackage
echo Extracting packages. . .
runonall extractpackage

printf "%s\n" "${packages[@]}" > build/etc/shpkg/pkgs.list

echo Building container. . .
docker build -t panux/panux .
