# WIP

export def "lock" [] {
    let busctl = get_busctl
    if $busctl != "" {
        ^$busctl --user call org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow lockAllDatabases
    } else {
        keepassxc --lock
    }
}

export def "open-default" [db_path: string] {
    let busctl = get_busctl
    if $busctl != "" {
        ^$busctl --user call org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow openDatabase s $db_path
    } else {
        keepassxc $db_path
    }
}

def get_local_path [] {
    $env.PASSWORD_MANAGER_LOCAL_PATH | path expand
}

def get_remote_url [] {
    $env.PASSWORD_MANAGER_REMOTE_URL
}

def get_busctl [] { 
    which busctl | get -i 0.path | default ""
}
