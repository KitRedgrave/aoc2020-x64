# What's this?
This is a premade dev environment for my own projects, so I only have to think about this in one place.

It is very much opinionated and based upon my own particular wants and circumstances. YMMV :)

## Links referenced
* https://nixos.wiki/wiki/Development_environment_with_nix-shell
* https://github.com/nix-community/nix-direnv
* https://direnv.net

## Things included
* nix shell config, for reproducible and distro-independent prereq handling (also to keep the cruft where it belongs)
* direnv setup, for convenience

## Things not included
* lorri, because I use Nix on WSL2 Ubuntu and systemd is not a thing here (I tried, way too janky of a work around for me)

## Initial setup
1. Install nix and direnv on your system somehow (however you prefer)
2. Hook direnv into your shell (see: https://direnv.net/docs/hook.html)
3. Allow direnv to load here (`direnv allow .` in repo root)

## Complementary additions outside repo
* home-manager to declaratively handle home dir stuff (maybe i'll throw my config in a separate repo)
* nix-direnv for caching derivations and keeping it fast

## Possible future work
* Magic to connect VS Code in with this as remote?
* git-crypt secret env vars checked for in .envrc?
* Convert to nix flakes if that ever reaches stable or is usable in WSL2? (do research here)
* Use Starship? (https://starship.rs) 
