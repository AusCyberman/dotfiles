{pkgs, ...}:
let cocSettings = ./coc.vim;
    in
{
    programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [ 
      { plugin = vim-airline;
      config = ''
        let g:airline_powerline_fonts = 1
        let g:airline_theme='fruit_punch'
        '';}
        vim-addon-nix vim-indent-guides vim-airline-themes vim-fish
        purescript-vim vimsence fzf-vim indentLine
	{ plugin = coc-nvim;
	  config = ''let g:coc_user_config = {'languageserver':{
	\	'haskell': {
	\	  'command': 'haskell-language-server-wrapper',
	\	  'args': ['--lsp'],
	\	  'rootPatterns': ['*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml'],
	\	  'filetypes': ['haskell', 'lhaskell']
	\	},
	\      'nix': {
	\	  'command': 'rnix-lsp',
	\	  'filetypes': [
	\	    'nix'
	\	  ]
	\	},
    \     "purescript": {
    \         "command": "purescript-language-server",
    \         "args": ["--stdio"],
    \         "filetypes": ["purescript"],
    \         "rootPatterns": ["bower.json", "psc-package.json", "spago.dhall"]
    \       },
    \ "rust": {
    \  "command": "rust-analyzer",
    \  "filetypes": ["rust"],
    \ "rootPatterns": ["Cargo.toml"]
    \  },
    \   "ccls": {
    \   "command": "ccls",
    \   "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp"],
    \   "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
    \   "initializationOptions": {
    \       "cache": {
    \         "directory": "/tmp/ccls"
    \       }
    \     }
    \   }
    \  }}


	  ''; }

	  ];
        extraConfig = ''
          set rnu nu
          set hidden
          syntax on
          filetype on
          filetype plugin indent on
	      so ${cocSettings}




          '';


  };}