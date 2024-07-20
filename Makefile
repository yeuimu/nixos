rebuild:
	sudo nixos-rebuild switch --flake .#wsl --show-trace --option substituters http://mirrors.tuna.tsinghua.edu.cn/nix-channels/store --option eval-cache false

list:
	sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
