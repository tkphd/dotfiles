# dotfiles

Configuration files for [`bash`](https://www.gnu.org/software/bash/),
[`emacs`](https://www.gnu.org/software/emacs/),
[`git`](https://git-scm.com/),
[`i3wm`](https://i3wm.org/)
with my personal preferences.

Run `setup.sh` to symlink the contents of this folder to the
appropriate user locations (`~/.bashrc`, `~/.emacs.d/init.el`, etc).

## Extra Packages

[Julia Evans][jvns] and [Ibraheem Ahmed][ibra] have collections of classic and
new Unix commands to make life faster, prettier, or otherwise better. Several
of these are packages for Debian!

```bash
declare -A debian_pkg

debian_pkg[silversearcher-ag]="a code searching tool similar to ack, but faster"
debian_pkg[bat]="a cat clone with syntax highlighting and Git integration"
debian_pkg[exa]="a modern replacement for ls"
debian_pkg[duf]="a better df alternative"
debian_pkg[fd]="a simple, fast and user-friendly alternative to find"
debian_pkg[fzf]="a general purpose fuzzy finder"
debian_pkg[httpie]="a modern, user-friendly HTTP client for the API era"
debian_pkg[jq]="sed for JSON data"
debian_pkg[lsd-musl]="the next-gen file listing command"
debian_pkg[ripgrep]="an extremely fast gitignore-aware alternative to grep"
debian_pkg[zoxide]="a smarter cd command inspired by z"

echo ${!debian_pkg[*]}
apt install ${!debian_pkg[*]}
```

Rust packages are installable from <https://crates.io>!

```bash
declare -A cargo_pkg

cargo_pkg[bottom]="yet another cross-platform graphical process monitor"
cargo_pkg[choose]="a human-friendly and fast alternative to cut and awk"
cargo_pkg[gping]="ping, but with a graph"
cargo_pkg[hyperfine]="a command-line benchmarking tool"
cargo_pkg[mcfly]="fly through your shell history"
cargo_pkg[procs]="a modern replacement for ps"
cargo_pkg[sd]="an intuitive find & replace (sed alternative)"
cargo_pkg[xh]="a friendly and fast tool for sending HTTP requests"

echo ${!cargo_pkg[*]}
cargo install ${!cargo_pkg[*]} 
```

Some Rust packages must be built from source.

```bash
declare -A cargo_pkg

cargo_pkg[broot]="a new way to see and navigate directory trees"
cargo_pkg[delta]="a viewer for git and diff output"
cargo_pkg[dog]="a user-friendly DNS client: dig on steroids"
cargo_pkg[dust]="a more intuitive version of du written in rust"

echo ${!cargo_pkg[*]}
declare -A cargo_src

cargo_src[broot]=""
cargo_src[delta]=""
cargo_src[dog]=""
cargo_src[dust]=""

```

Go packages are installable from Go!

```bash
declare -A go_pkg

go_pkg[cheat]="create and view interactive cheatsheets on the command-line"
go_pkg[curlie]="the power of curl, the ease of use of httpie"

echo ${!go_pkg[*]}

declare -A go_src

go_src[cheat]="github.com/cheat/cheat/cmd/cheat"
go_pkg[curlie]="github.com/rs/curlie"

for PKG in ${go_src[*]}; do
    go get -u ${PKG}
done
```

Node packages are installable with `nvm`!

```bash
declare -A node_pkg

node_pkg[tldr]="a community effort to simplify man pages with practical examples"

echo ${!node_pkg[*]}
nvm install ${!node_pkg[*]}
```

Some are even available through Pip!

```bash
declare -A pypi_pkg

pypi_pkg[glances]="a top/htop alternative"

echo ${!pypi_pkg[*]}
pip install --user ${!pypi_pkg[*]}
```

<!-- links -->
[jvns]: https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
[ibra]: https://github.com/ibraheemdev/modern-unix
