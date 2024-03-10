### Planned file structure

```
.nixdots
├── .git
│   └── ...
├── hosts
│   └── omen-15
│       ├── hardware-configuration.nix
│       └── user-config.nix
├── modules
│   ├── core
│   │   ├── configuration.nix
│   │   ├── eduroam.patch
│   │   └── nvidia.nix
│   └── home
│       ├── desktop
│       │   ├── apps
│       │   │   └── ...
│       │   ├── browser
│       │   │   └── ...
│       │   ├── gaming
│       │   │   └── ...
│       │   ├── media
│       │   │   └── ...
│       │   ├── term
│       │   │   └── ...
│       │   └── vm
│       │       └── ...
│       ├── dev
│       │   └── ...
│       ├── editors
│       │   ├── nvim
│       │   └── vscode
│       └── shell
│           └── ...
├── flake.lock
└── flake.nix
```