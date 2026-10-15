# WIP
export def password [] { help password }

export def "password lock" [] {
    let busctl = get_busctl
    if $busctl != "" {
        ^$busctl --user call org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow lockAllDatabases
    } else {
        keepassxc --lock
    }
}

export def "password open-default" [] {
    let busctl = get_busctl
    let db_path = $"(get_local_path)/database.kdbx"
    if $busctl != "" {
        ^$busctl --user call org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow openDatabase s $db_path
    } else {
        keepassxc $db_path
    }
}

def get_busctl [] {
    which busctl | get -i 0.path | default ""
}

def get_local_path [] {
    $env.PASSWORDS_NU_LOCAL_PATH | path expand
}

def get_remote_url [] {
    $env.PASSWORDS_NU_REMOTE_URL
}
