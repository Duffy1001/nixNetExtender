{pkgs ? import <nixpkgs> {}}:

pkgs.stdenv.mkDerivation rec {
	pname="netextender";
	version="10.3.0-21";
	src = pkgs.fetchurl {
	url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-10.3.0-21.tar.gz";
	sha256 = "1mwx89iv25jrc6igs7cnplgkwk1a1bmqn39x9vkw608c2hlpywd6"	;
};
	buildPhase = "true";
	installPhase = ''
	mkdir -p $out/usr/local
	cp ../netextender -r $out/usr/local
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/usr/local/netextender/nxcli
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/usr/local/netextender/NEService
chmod +x $out/usr/local/netextender/neservice
	'';
	meta = with pkgs.lib; {
		description = "Sonicwall NetExtender VPN Client";
		homepage="https://software.sonicwall.com";
		license = licenses.unfree;
		platforms = platforms.linux;
	};
}
