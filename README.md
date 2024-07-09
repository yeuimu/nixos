
When you want to build system on new host using this config, you have to produce a hardware nix file depending on your host.

```bash
nixos-generate-config --root /mnt
```

This instruction will new `hardware-configuration.nix` file which descript hardware infomations such as `partition`, `mount`....

> Nix minimal ISO no `git`, you need install it using `nix-env -iA nixos.git --option substituters https://mirrors.bfsu.edu.cn/nix-channels/store`.
