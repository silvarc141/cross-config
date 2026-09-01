# Get a single path from stdin and pass it to $env.EDITOR.
#
# Works differently depending on stdin type:
# - string: uses lines of the string as paths.
# - list: uses list elements as paths.
# - for table: uses "path" or "name" column as paths and "title" column for interactive selection display name.
export def edit [] {
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
