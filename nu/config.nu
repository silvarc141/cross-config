use ./modules/module-shell.nu *
use ./modules/module-note.nu *

$env.PROMPT_INDICATOR = $'(ansi {fg: cyan_dimmed})󰬪 '
$env.config = {
  cursor_shape: {
    emacs: block
  },
  keybindings: [
    {
      event: {
        until: [
          {
            name: completion_menu,
            send: menu
          },
          [
            {
              send: enter
            }
          ]
        ]
      },
      keycode: tab,
      mode: [
        emacs,
        vi_insert
      ],
      modifier: none,
      name: start_and_confirm_completion
    }
  ],
  menus: [
    {
      marker: 󰟃 ,
      name: completion_menu,
      only_buffer_difference: false,
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green
      },
      type: {
        columns: 1,
        layout: columnar
      }
    },
    {
      marker: 󰋗 ,
      name: help_menu,
      only_buffer_difference: true,
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green
      },
      type: {
        col_padding: 2,
        col_width: 20,
        columns: 4,
        description_rows: 10,
        layout: description,
        selection_rows: 4
      }
    },
    {
      marker: 󱍷 ,
      name: history_menu,
      only_buffer_difference: true,
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green
      },
      type: {
        layout: list,
        page_size: 10
      }
    }
  ],
  rm: {
    always_trash: false
  },
  show_banner: false,
  table: {
    header_on_separator: true,
    index_mode: auto,
    mode: light,
    padding: {},
    show_empty: false
  }
}

alias v = ^$env.EDITOR

alias l = ls
alias la = ls -a
alias ll = ls -l
alias lla = ls -la
alias lal = ls -la
alias fg = job unfreeze

alias g = ^git
alias gs = ^git status -s
alias gss = ^git status

alias gd = ^git diff
alias gdc = ^git diff --cached

alias gl = ^git log --graph --full-history --all --abbrev-commit
alias glp = ^git log --graph --oneline --patch --ext-diff
alias glt = ^git log --graph --full-history --all --oneline --simplify-by-decoration

alias ga = ^git add
alias gaa = ^git add -A

alias gc = ^git commit
alias gcn = ^git commit --amend
alias gcm = ^git commit -m
alias gcam = ^git commit -am

alias gp = ^git push
alias gpl = ^git pull
