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
