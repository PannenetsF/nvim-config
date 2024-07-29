import os


def get_host_type():
    # linux, mac
    if os.uname()[0].lower() == "linux":
        return "linux"
    elif os.uname()[0].lower() == "darwin":
        return "mac"
    else:
        raise Exception(f"Unsupported OS {os.uname()}")


def get_linux_packager():
    # apt, yum, pacman
    # find if the exe is available
    if os.path.exists("/usr/bin/apt"):
        return "apt", "apt update -y"
    elif os.path.exists("/usr/bin/yum"):
        return "yum", "yum update -y"
    elif os.path.exists("/usr/bin/pacman"):
        return "pacman", "pacman -Syu --noconfirm"
    else:
        raise Exception("Unsupported Linux packager")


def linux_package_install(packager, packages):
    commands = []
    for package in packages:
        if packager == "apt":
            commands.append(f"DEBIAN_FRONTEND=noninteractive apt-get install -y {package}")
        elif packager == "yum":
            commands.append(f"yum install -y {package}")
        elif packager == "pacman":
            commands.append(f"pacman -Sy --noconfirm {package}")
        else:
            raise Exception("Unsupported Linux packager")
    return commands


def mac_package_install(packages):
    commands = []
    for package in packages:
        commands.append(f"brew install -y {package}")
    return commands


def install(packager, packages):
    if packager == "brew":
        return mac_package_install(packages)
    else:
        return linux_package_install(packager, packages)


def curl_install(url, dst, post):
    get_files = f"curl -L {url} -o {dst}"
    return [get_files] + post


# name, package name, skip_mac, skip_apt, skip_yum, skip_pacman
system_packages = [
    ("git", ["git"], False, False, False, False),
    ("curl", ["curl"], False, False, False, False),
    ("wget", ["wget"], False, False, False, False),
    ("lua", ["lua"], False, True, False, False),
    ("lua", ["lua5.4"], True, False, True, True),
    ("openssh", ["openssh-server"], True, False, False, False),
    ("zsh", ["zsh"], False, False, False, False),
    ("tmux", ["tmux"], False, False, False, False),
    ("ripgrep", ["ripgrep"], False, False, False, False),
    ("fzf", ["fzf"], False, False, False, False),
]


def oh_my_zsh_get_curl():
    return (
        "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh",
        "/tmp/install.sh",
    )


def oh_my_zsh_post_install(dest):
    r"""
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    """
    commands = []
    commands.append(f"sh {dest} -- --unattended")
    return commands


def node_get_curl():
    r"""
    https://nodejs.org/dist/v20.14.0/node-v20.14.0-darwin-arm64.tar.gz
    https://nodejs.org/dist/v20.14.0/node-v20.14.0-darwin-x64.tar.gz
    https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-x64.tar.xz
    https://nodejs.org/dist/v20.14.0/node-v20.14.0-linux-arm64.tar.xz
    """
    host = get_host_type()
    cpu_arch = os.uname()[-1]
    sys = "darwin" if host == "mac" else "linux"
    arch = "x64" if cpu_arch == "x86_64" else "arm64"
    version = "v20.14.0"
    url = f"https://nodejs.org/dist/{version}/node-{version}-{sys}-{arch}.tar.xz"
    dest = "/tmp/node.tar.xz"
    return url, dest


def node_post_install(dest):
    commands = []
    tgt = "~/pfbin/node/"
    # unzip
    commands.append(f"mkdir -p {tgt}")
    commands.append(f"tar -xf {dest} -C {tgt}")
    # mv the folder
    commands.append(f"mv {tgt}/*/* {tgt}")
    needed_env = f"export PATH=\\$PATH:{tgt}/bin"
    commands.append(f'echo "{needed_env}" >> ~/.zshrc')
    commands.append(f'echo "{needed_env}" >> ~/.bashrc')
    commands.append(needed_env)
    return commands


def nvim_get_curl():
    r"""
    https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
    https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-macos-arm64.tar.gz
    https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-macos-x86_64.tar.gz
    """
    host = get_host_type()
    cpu_arch = os.uname()[-1]
    sys = "macos" if host == "mac" else "linux64"
    if host == "mac":
        arch = "arm64" if cpu_arch == "arm64" else "x86_64"
        sys = f"macos-{arch}"
    version = "v0.10.0"
    url = f"https://github.com/neovim/neovim/releases/download/{version}/nvim-{sys}.tar.gz"
    dest = "/tmp/nvim.tar.gz"
    return url, dest


def nvim_post_install(dest):
    commands = []
    tgt = "~/pfbin/nvim/"
    # unzip
    commands.append(f"mkdir -p {tgt}")
    commands.append(f"xattr -c {dest}")
    commands.append(f"tar -xf {dest} -C {tgt}")
    commands.append(f"mv {tgt}/*/* {tgt}")
    needed_env = f"export PATH=\\$PATH:{tgt}/bin"
    commands.append(f'echo "{needed_env}" >> ~/.zshrc')
    commands.append(f'echo "{needed_env}" >> ~/.bashrc')
    commands.append(needed_env)
    # add alias v and vim
    commands.append('echo "alias v=nvim" >> ~/.bashrc')
    commands.append('echo "alias vim=nvim" >> ~/.bashrc')
    commands.append('echo "alias v=nvim" >> ~/.zshrc')
    commands.append('echo "alias vim=nvim" >> ~/.zshrc')
    # config
    commands.append("mkdir -p ~/.config/")
    commands.append("git clone https://github.com/PannenetsF/nvim-config.git ~/.config/nvim")
    return commands


def gh_get_curl():
    """
    https://github.com/cli/cli/releases/download/v2.50.0/gh_2.50.0_linux_amd64.tar.gz
    https://github.com/cli/cli/releases/download/v2.50.0/gh_2.50.0_linux_arm64.tar.gz
    https://github.com/cli/cli/releases/download/v2.50.0/gh_2.50.0_macOS_amd64.zip
    https://github.com/cli/cli/releases/download/v2.50.0/gh_2.50.0_macOS_arm64.zip
    """
    host = get_host_type()
    cpu_arch = os.uname()[-1]
    sys = "macOS" if host == "mac" else "linux"
    arch = "amd64" if cpu_arch == "x86_64" else "arm64"
    version = "v2.50.0"
    fm = "zip" if host == "mac" else "tar.gz"
    url = f"https://github.com/cli/cli/releases/download/{version}/gh_{version[1:]}_{sys}_{arch}.{fm}"
    dest = f"/tmp/gh.{fm}"
    return url, dest


def gh_post_install(dest):
    commands = []
    tgt = "~/pfbin/gh/"
    # unzip
    commands.append(f"mkdir -p {tgt}")
    if dest.endswith(".zip"):
        commands.append(f"unzip {dest} -d {tgt}")
    elif dest.endswith(".tar.gz"):
        commands.append(f"tar -xf {dest} -C {tgt}")
    commands.append(f"mv {tgt}/*/* {tgt}")
    needed_env = f"export PATH=\\$PATH:{tgt}/bin"
    commands.append(f'echo "{needed_env}" >> ~/.zshrc')
    commands.append(f'echo "{needed_env}" >> ~/.bashrc')
    commands.append(needed_env)
    return commands


def lazygit_get_curl():
    r"""
    https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Darwin_x86_64.tar.gz
    https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Darwin_arm64.tar.gz
    https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Linux_arm64.tar.gz
    https://github.com/jesseduffield/lazygit/releases/download/v0.42.0/lazygit_0.42.0_Linux_x86_64.tar.gz
    """
    host = get_host_type()
    cpu_arch = os.uname()[-1]
    sys = "Darwin" if host == "mac" else "Linux"
    arch = "x86_64" if cpu_arch == "x86_64" else "arm64"
    version = "v0.42.0"
    url = (
        "https://github.com/jesseduffield/lazygit/releases/download/{version}/"
        f"lazygit_{version[1:]}_{sys}_{arch}.tar.gz"
    )
    dest = "/tmp/lazygit.tar.gz"
    return url, dest


def lazygit_post_install(dest):
    commands = []
    tgt = "~/pfbin/lazygit/"
    # unzip
    commands.append(f"mkdir -p {tgt}")
    commands.append(f"tar -xf {dest} -C {tgt}")
    needed_env = f"export PATH=\\$PATH:{tgt}/"
    commands.append(f'echo "{needed_env}" >> ~/.zshrc')
    commands.append(f'echo "{needed_env}" >> ~/.bashrc')
    return commands


def git_post_init():
    # set user name and email
    # set editor to nvim
    return [
        "git config --global user.name 'PannenetsF'",
        "git config --global user.email 'pannenets.f@foxmail.com'",
        "git config --global core.editor nvim",
    ]


# name, url_fn, post_fn,
curl_packages = [
    ("oh-my-zsh", oh_my_zsh_get_curl, oh_my_zsh_post_install),
    ("node", node_get_curl, node_post_install),
    ("nvim", nvim_get_curl, nvim_post_install),
    ("gh", gh_get_curl, gh_post_install),
    ("lazygit", lazygit_get_curl, lazygit_post_install),
]

npm_pacakges = [
    "vim-language-server",
]

pip_pacakges = [
    "pynvim",
    "python-lsp-server[all]",
    "pylsp-mypy",
    "python-lsp-isort",
    "python-lsp-black",
]

post_init_fns = [
    git_post_init,
]


def main():
    commands = []
    host_type = get_host_type()
    if host_type == "linux":
        packager, update = get_linux_packager()
        commands.append(update)
    else:
        packager = "brew"

    for name, packages, skip_mac, skip_apt, skip_yum, skip_pacman in system_packages:
        if host_type == "mac" and skip_mac:
            continue
        if packager == "apt" and skip_apt:
            continue
        if packager == "yum" and skip_yum:
            continue
        if packager == "pacman" and skip_pacman:
            continue
        commands += install(packager, packages)

    for name, url_fn, post_fn in curl_packages:
        url, dst = url_fn()
        commands += curl_install(url, dst, post_fn(dst))

    for name in npm_pacakges:
        commands.append(f"npm install -g {name}")

    for name in pip_pacakges:
        commands.append(f"pip install -U {name}")

    for fn in post_init_fns:
        commands += fn()

    for i in commands:
        print(i)


if __name__ == "__main__":
    main()
