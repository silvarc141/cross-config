# Required env:
# - EDITOR - text editor

# Edit files at paths provided from stdin using $env.EDITOR
export def "edit" [] {
    let input = $in
    let inputType = $input | describe

    let paths = if ($inputType | str contains "table") {
        if "path" in ($input | columns) {
            $input.path
        } else if "name" in ($input | columns) {
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

    let clean_paths = $paths | each { into string } | where ($it | str length) > 0

    if ($clean_paths | is-empty) {
        print "No valid file paths to edit."
        return
    }

    ^$env.EDITOR ...$clean_paths
}
