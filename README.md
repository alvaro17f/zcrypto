# zcrypto

![](vhs/zcrypto.gif)

zcrypto is a command line tool for watching crypto coin prices.

> :warning: **Work in Progress**: This project is currently under development. Some features may not be complete and may change in the future.
## Installation

To install zcrypto, you can clone the repository and compile the source code:

```sh
git clone https://github.com/alvaro17f/zcrypto.git
cd zcrypto
zig build run
```

then move the binary to a directory in your PATH:

```sh
sudo mv zig-out/bin/zcrypto <PATH>
```

### NixOS

#### Run
To run zcrypto, you can use the following command:

```sh
nix run github:alvaro17f/zcrypto#target.x86_64-linux-musl
```

#### Flake
Add zcrypto to your flake.nix file:

```nix
{
    inputs = {
        zcrypto.url = "github:alvaro17f/zcrypto";
    };
}
```

then include it in your system configuration:

```nix
{ inputs, pkgs, ... }:
{
    home.packages = [
        inputs.zcrypto.packages.${pkgs.system}.default
    ];
}
```

## Usage
```sh
 ***************************************************
 ZCRYPTO - A tool to watch crypto coin prices
 ***************************************************
 -s : coin to search
 -h, help : Display this help message
 -v, version : Display the current version

```


## License
zcrypto is distributed under the MIT license. See the LICENSE file for more information.

