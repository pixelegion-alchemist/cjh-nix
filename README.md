# cjh-nix
My Nix setup

Useful commands:
``` 
nix run .#packages.x86_64-linux.default          # system nix.conf
nix run .#packages.x86_64-linux.installUserNixConf
nix run .#homeConfigurations.${USER}.activationPackage
```