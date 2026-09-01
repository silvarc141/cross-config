use ./modules/note.nu

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
            marker: "󰟃 ",
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
            marker: "󰋗 ",
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
            marker: "󱍷 ",
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

$env.PROMPT_INDICATOR = $'(ansi {fg: cyan_dimmed})󰬪 '

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
alias gcm = ^git commit -m
alias gca = ^git commit -a
alias gcam = ^git commit -am
alias gcn = ^git commit --amend
alias gp = ^git push
alias gpl = ^git pull

# Get a single path from stdin and pass it to $env.EDITOR.
#
# Works differently depending on stdin type:
# - string: uses lines of the string as paths.
# - list: uses list elements as paths.
# - for table: uses "path" or "name" column as paths and "title" column for interactive selection display name.
export def "edit" [] {
    let input = $in
    let inputType = $input | describe

    let display_names = if ($inputType | str contains "table") {
        let cols = $input | columns
        if (("path" in $cols or "name" in $cols) and "title" in $cols) {
            $input.title 
        }
    }

    let paths = if ($inputType | str contains "table") {
        let cols = $input | columns
        if "path" in $cols {
            $input.path
        } else if "name" in $cols {
            $input.name
        } else {
            error make {msg: "Table input must have a 'path' or 'name' column"}
        }
    } else if ($inputType | str contains "list") {
        $input
    } else if ($inputType | str contains "string") {
        $input | lines | str trim
    } else if ($inputType | str contains "nothing") {
        [ "" ]
    } else {
        error make {msg: "Unsupported input type. Please provide a string, list, or table."}
    }

    let clean_paths = $paths | each { into string } 
        | where ($it | str length) > 0 
        | where ($it | path exists)

    if ($clean_paths | is-empty) {
        print "No non-empty paths to edit."
        return
    }

    let index = if ($clean_paths | length) == 1 {
        0
    } else if ($display_names | is-empty) {
        $clean_paths | input list --index --no-footer
    } else {
        $display_names | input list --index --no-footer
    }

    if ($index | is-empty) { return }

    ^$env.EDITOR ($clean_paths | get $index )
}
