{ inputs, config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian H. Ward";
        email = "glyphrider@gmail.com";
      };
    };
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };
  };

  home.shell = {
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    history = {
      append = true;
      findNoDups = true;
      ignoreAllDups = true;
      save = 10000;
      size = 10000;
      saveNoDups = true;
      share = true;
    };
    shellAliases = {
      "awsume" = ". awsume";
      "hyprland" = "uwsm start hyprland-uwsm.desktop";
    };
    syntaxHighlighting = {
      enable = true;
    };
    initContent = ''
      prompt off
      export PS1="%F{magenta}%n@%m%f 󱄅 %F{blue}%~%f %(?.%F{green}.%F{red})>>>%f "
      if [ -z "$XDG_RUNTIME_DIR" ]; then
        export XDG_RUNTIME_DIR=/run/user/$(id -u)
      fi
    '';
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      filetype plugin indent on
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set autoindent
      set number
      set relativenumber
      set backspace=indent,eol,start
      set incsearch
      set hlsearch
      set ignorecase
      set smartcase
      set wildmenu
      set scrolloff=5
      set clipboard=unnamedplus
      syntax on
      nnoremap <Esc> :noh<CR>
    '';
  };

  programs.tmux = {
    enable = true;
    shortcut = "Space";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank

      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'macchiato'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_flags 'icon'
          run-shell "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux"
          set -g status-right-length 200
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          # set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }
      cpu
      battery
    ];
    extraConfig = ''
      # The border-status is very handy when building large projects (i.e. Gentoo),
      # because tmux will show you where you are along the way
      #set -g pane-border-status top

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window
      
      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    # systemd.variables = [ "--all" ];
    # configType = "lua";
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod SHIFT, X, exit"
      ] ++ (
        builtins.concatLists (
          builtins.genList (
            i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );
    };
  };

  xdg.configFile."nvim" = {
    source = "${inputs.nvim-config}";
    recursive = true;
  };

  home.stateVersion = "25.11";
}

