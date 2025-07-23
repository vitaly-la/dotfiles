{ lib, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";

    username = "user";
    homeDirectory = "/home/user";

    file = {
      ".config/user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/Desktop"
        XDG_DOWNLOAD_DIR="$HOME/Downloads"
        XDG_TEMPLATES_DIR="$HOME/Downloads"
        XDG_PUBLICSHARE_DIR="$HOME/Downloads"
        XDG_DOCUMENTS_DIR="$HOME/Downloads"
        XDG_MUSIC_DIR="$HOME/Downloads"
        XDG_PICTURES_DIR="$HOME/Downloads"
        XDG_VIDEOS_DIR="$HOME/Downloads"
      '';

      ".config/mpv/mpv.conf".text = ''
        ao=pulse
        mute=yes
        window-maximized=yes
      '';
    };

    shellAliases = {
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      ls = "ls --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      br = "git br";
      ci = "git ci";
      co = "git co";
      st = "git st";
      add = "git add";
      clean = "git clean";
      log = "git log";
      pull = "git pull";
      push = "git push";
    };

    packages = with pkgs; [
      wget
      htop
      file # for fzf-vim
      mpv
      monaspace
      ripgrep
      dnsutils
      moreutils
      comma

      telegram-desktop
    ];

    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;

      historySize = 1000000;
      historyFileSize = 1000000;

      initExtra = ''
        # Provide a nice prompt if the terminal supports it.
        if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
          PROMPT_COLOR="1;31m"
          ((UID)) && PROMPT_COLOR="1;32m"
          if [ -n "$INSIDE_EMACS" ]; then
            # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
            PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\u:\w\007\]$PS1"
          fi
        fi
      '';
    };

    fzf.enable = true;

    tmux.enable = true;

    git = {
      enable = true;
      userName = "vitaly-la";
      userEmail = "148568747+vitaly-la@users.noreply.github.com";
      aliases = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };
      extraConfig = {
        core.editor = "vim";
      };
    };

    firefox.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
      ];
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ iceberg-vim vim-airline vim-cool fzf-vim vim-fugitive ale nerdtree ];
      extraConfig = ''
        set background=dark
        colorscheme iceberg

        syntax on
        filetype plugin indent on
        set number
        set mouse=a
        nmap j gj
        nmap k gk
        set hlsearch
        set incsearch
        set autoindent
        set smartindent
        set tabstop=4
        set shiftwidth=4
        set expandtab

        nnoremap <C-p> :Files<CR>

        let mapleader=","
        nnoremap <leader>f :RG<CR>

        let g:ale_hover_to_floating_preview=1
        nmap gd :ALEGoToDefinition<CR>
        nmap gr :ALEFindReferences<CR>
        nmap K :ALEHover<CR>
        set omnifunc=ale#completion#OmniFunc
      '';
    };
  };
}
