{
  description = "Gazebo Hi-DPi fix using env settings";

  inputs = {
    wafer.url = "github:zoenglinghou/wafer?ref=main";

    flake-utils.follows = "wafer/utils";
    nixpkgs.follows = "wafer/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pname = "gazebo-hidpi-fix";
        gazebo_wrapper_name = "gazebo";
        gzclient_wrapper_name = "gzclient";
        gazebo_wrapper_src = builtins.readFile ./gazebo;
        gzclient_wrapper_src = builtins.readFile ./gzclient;
        gazebo_wrapper = (pkgs.writeShellScriptBin gazebo_wrapper_name
          gazebo_wrapper_src).overrideAttrs
          (old: { dontPatchShebangs = true; });
        gzclient_wrapper = (pkgs.writeShellScriptBin gzclient_wrapper_name
          gzclient_wrapper_src).overrideAttrs (old: { dontPatchShebangs = true; });
      in rec {
        defaultPackage = packages.pname;
        packages.pname = pkgs.symlinkJoin {
          name = pname;
          paths = [ gazebo_wrapper gzclient_wrapper ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/${gazebo_wrapper_name} --prefix PATH : $out/bin
            wrapProgram $out/bin/${gzclient_wrapper_name} --prefix PATH : $out/bin
          '';
        };
      });
}
