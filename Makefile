VERSION := 1.22.0

all: _gokrazy/extrafiles_arm64.tar _gokrazy/extrafiles_amd64.tar

_gokrazy/extrafiles_amd64.tar:
	mkdir -p _gokrazy/extrafiles_amd64/usr/local/bin
	curl -fsSL https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-amd64-v${VERSION}.tar.gz | \
		tar xzv --strip-components=1 -C _gokrazy/extrafiles_amd64/usr/local/bin/ --wildcards \
                syncthing-linux-*-v${VERSION}/syncthing syncthing-linux-*/LICENSE.txt
	mv _gokrazy/extrafiles_amd64/usr/local/bin/LICENSE.txt _gokrazy/extrafiles_amd64/usr/local/bin/LICENSE.syncthing
	cd _gokrazy/extrafiles_amd64 && tar cf ../extrafiles_amd64.tar *
	rm -rf _gokrazy/extrafiles_amd64

_gokrazy/extrafiles_arm64.tar:
	mkdir -p _gokrazy/extrafiles_arm64/usr/local/bin
	curl -fsSL https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-arm64-v${VERSION}.tar.gz | \
		tar xzv --strip-components=1 -C _gokrazy/extrafiles_arm64/usr/local/bin/ --wildcards \
                syncthing-linux-*-v${VERSION}/syncthing syncthing-linux-*/LICENSE.txt
	mv _gokrazy/extrafiles_arm64/usr/local/bin/LICENSE.txt _gokrazy/extrafiles_arm64/usr/local/bin/LICENSE.syncthing
	cd _gokrazy/extrafiles_arm64 && tar cf ../extrafiles_arm64.tar *
	rm -rf _gokrazy/extrafiles_arm64

clean:
	rm -f _gokrazy/extrafiles_*.tar
