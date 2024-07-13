## Plugins

```
.
├── init.lua
├── lazy-lock.json
├── lua
│   ├── init
│   │   ├── autocmd.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   ├── plugins
│   │   ├── coding.lua
│   │   └── ui.lua
│   └── term
│       └── init.lua
└── README.md
```

- `init.lua` => init -> `keymaps.lua` -> `autocmd.lua` -> `options.lua` -> `lazy.lua` => plugins
- UI plugins: tokyonight, bufferline, nvim-tree, gitsigns, term(local plugin)
- Coding plugins: mason, lsp, cmp(luasinp, autopairs), outlien, treesitter, conform, markdown(headlines), lua(neodev), rust(rustaceanvim)

## Config

1. `init/*.lua`: To config nvim basic setting.
2. `plugins/coding`: To config on relation with coding.
3. `plugins/ui`: To config on relation with UI.

## Inspiration

- [LazyVim](https://github.com/LazyVim/LazyVim/tree/main)
- [NvChad](https://github.com/NvChad/NvChad)
- [IceNvim](https://github.com/Shaobin-Jiang/IceNvim)
- [Shaobin Jiang](https://shaobin-jiang.github.io/blog/)
