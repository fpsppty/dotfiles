$env.config.show_banner = false

let vendor = ($nu.data-dir | path join "vendor/autoload")
mkdir $vendor

# https://carapace-sh.github.io/carapace-bin/setup.html
if (which carapace | is-not-empty) {
    carapace _carapace nushell | save --force ($vendor | path join "carapace.nu")
}
# https://mise.jdx.dev/installing-mise.html#nushell
if (which mise | is-not-empty) {
    mise activate nu | save --force ($vendor | path join "mise.nu")
}
# https://starship.rs
if (which starship | is-not-empty) {
    starship init nu | save --force ($vendor | path join "starship.nu")
}

def e [path?: path] {
    let target = ($path | default $env.PWD)
    if $nu.os-info.name == "windows" {
        ^explorer $target
    } else if $nu.os-info.name == "macos" {
        ^open $target
    } else {
        ^xdg-open $target
    }
}

def --env q [] {
    let selected = (ghq list -p | fzf)
    if ($selected | is-not-empty) {
        cd $selected
    }
}
