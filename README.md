# passback

![](vhs/passback.gif)

passback is a command line tool for managing NixOS configuration.

> :warning: **Work in Progress**: This project is currently under development. Some features may not be complete and may change in the future.
## Installation

To install passback, you can clone the repository and compile the source code:

```sh
git clone https://github.com/alvaro17f/passback.git
cd passback
zig build run
```

then move the binary to a directory in your PATH:

```sh
sudo mv zig-out/bin/passback <PATH>
```

### NixOS

#### Run
To run passback, you can use the following command:

```sh
nix run github:alvaro17f/passback#target.x86_64-linux-musl
```

#### Flake
Add passback to your flake.nix file:

```nix
{
    inputs = {
        passback.url = "github:alvaro17f/passback";
    };
}
```

then include it in your system configuration:

```nix
{ inputs, pkgs, ... }:
{
    home.packages = [
        inputs.passback.packages.${pkgs.system}.default
    ];
}
```

## Usage
```sh
 ***************************************************
 PASSBACK - A tool to backup your keepass database
 ***************************************************
 -d : USB devices to backup to
 -p : Path to keepass db (default is ~/keepass)
 -h, help : Display this help message
 -v, version : Display the current version

```


## License
passback is distributed under the MIT license. See the LICENSE file for more information.
