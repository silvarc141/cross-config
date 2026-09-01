# Commands to sync, find and edit markdown notes.
#
# Depends on: ripgrep (rg), git, git-crypt
# Required env:
# - NOTES_NU_LOCAL_PATH - local directory where notes will be stored
# - NOTES_NU_REMOTE_URL - url to a git-crypt-encrypted notes repo
# - NOTES_NU_CRYPT_KEY_PATH - path to the key that allows notes repo decryption
# - EDITOR - markdown text editor
export def note [] { help note }

# Create or edit an existing note for a date.
# Date argument will be processed using nushell's "date from-human", allowing for input like "2002-10-12", "today", "yesterday" and more.
export def "note daily" [date_target: string = "today" ] {
    let date = $date_target | date from-human | format date "%F"

    let template_path = $"(get_local_path)/templates/dated.md"
    let initial_content = if ($template_path | path exists) { cat $template_path } else ""

    open_note $"(get_local_path)/dated/($date).md" $initial_content
}

# Create a new titled note.
export def "note new" [title: string] {
    let date = date now | format date "%F_%T_%f"
    let note_path = $"(get_local_path)/named/($date).md" 

    let template_path = $"(get_local_path)/templates/named.md"
    mut initial_content = if ($template_path | path exists) { open $template_path } else ""
    let initial_content = $"($initial_content)($in)"

    open_note $note_path $initial_content ($title | str capitalize)
}

# List titled notes whose titles match the provided query.
export def "note list" [title_query: string = ""] {
    ^rg $"^# .*($title_query).*" -m 1 -i $"(get_local_path)/named" --json 
    | from_rg_json
    | select lines_text text 
    | rename title path
    | update title { str trim | str substring 2.. }
    | sort
}

# Search through all notes content using ripgrep.
export def "note grep" [ripgrep_query: string] {
    ^rg -i $ripgrep_query (get_local_path)
}

# Sync note repository.
export def "note sync" [] {
    let local_path = get_local_path
    if not ($local_path | path exists) { mkdir ($local_path) }
    cd $local_path

    if not (".git" | path exists) {
        ^git init -b main
        ^git remote add origin (get_remote_url)

        if (^git fetch | complete).exit_code != 0 {
            rm -rf .git
            error make {msg: "Git fetch failed. Removing changes and exiting."}
        }

        ^git-crypt unlock (get_crypt_key_path)
        ^git checkout -b main origin/main --force
    }

    let lock_file = ".git/index.lock"
    if ($lock_file | path exists) { 
        rm $lock_file 
    }

    ^git branch --set-upstream-to=origin/main main

    ^git add -A
    try { 
        ^git commit -m $"(whoami)@(sys host | get hostname)" 
    }
    ^git pull --rebase origin main --autostash -X ours
    ^git push origin main
}

def from_rg_json [] {
    $in 
    | lines 
    | each { from json } 
    | where type == "match" 
    | get data 
    | flatten 
}

def open_note [relative_path: string, initial_content: string = "", title: string = ""] {
    let path = (get_local_path | path join $relative_path)
    let title = if ($title != "") { $"# ($title)\n\n" } else "";
    let content = $"($title)($initial_content)"
    mkdir ($path | path dirname)
    if not ($path | path exists) { $content | save $path -f }
    ^$env.EDITOR $path
}

def get_local_path [] {
    $env.NOTES_NU_LOCAL_PATH | path expand
}

def get_remote_url [] {
    $env.NOTES_NU_REMOTE_URL
}

def get_crypt_key_path [] {
    $env.NOTES_NU_CRYPT_KEY_PATH | path expand
}
