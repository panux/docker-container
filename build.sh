packages=(basefs busybox)
pkgsource="https://github.com/panux/packages-main.git"

function buildpackage() {
	local ret=$1
	local retval=$(docker run --rm -v $PWD/packages:/build panux/package-builder /build/$1.pkgen | grep $ret.tar.xz)
	eval $ret="'$retval'"
}

function pullpackage() {
	local pkg=$1
	local pkglnk=$1
	eval pkglnk=\$$pkglnk
	wget $pkglnk -O $pkg.tar.xz
}

function extractpackage() {
	local pkg=$1
	tar -xvf $pkg.tar.xz --exclude ./.pkginfo -C build
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
git clone $pkgsource packages

echo Packages:
runonall 'echo -e \t'
echo Generating packages. . .
runonall buildpackage
echo Pulling packages. . .
runonall pullpackage
echo Extracting packages. . .
runonall extractpackage
echo Building container. . .
docker build -t panux/panux .
