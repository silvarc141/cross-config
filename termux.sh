# WARNING: OUTDATED

termux-change-repo
pkg upgrade -y
pkg install nushell git git-crypt ripgrep 

# Optional setup:
# chsh nu

# Run with something like this:
# . $(curl -s https://raw.githubusercontent.com/silvarc141/cross-config/main/termux.sh)


# nu -c '
# let lib = http get https://raw.githubusercontent.com/silvarc141/notes-nu/main/lib.nu
# let dir = $nu.user-autoload-dirs | first
# mkdir $dir
# $lib o> ($dir | path join "notes.nu")
# '
