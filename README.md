# ArchInstall

ArchInstall is an installation script for arch linux

## How to use

- Download the latest live iso from [archlinux.org](https://archlinux.org/download/)
- Flash it to an USB drive
- Boot it

Then you have 2 options

- Install git and run locally
  - Run `pacman -Sy git` to install git
  - Run `git clone https://github.com/coderadu/archinstall`
  - Run `cd archinstall`
  - Run `./archinstall.sh` and follow the instructions
- Use the nogit version
  - Run `bash -c "$(curl -sSL https://raw.githubusercontent.com/CodeRadu/ArchInstall/main/archinstall.sh)" -s nogit
