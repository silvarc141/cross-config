# Optional before: 
# termux-change-repo
# pkg upgrade -y

# Run with something like this:
# . $(curl -s https://raw.githubusercontent.com/silvarc141/cross-config/main/termux.sh)

# Optional after: 
# chsh nu

pkg install nushell git git-crypt ripgrep 

nu -c '
let dir = $nu.user-autoload-dirs | first
mkdir $dir
cd $dir
git clone https://github.com/silvarc141/cross-config.git
cp -rf ./cross-config/nu/* ./
rm -rf ./cross-config
'
