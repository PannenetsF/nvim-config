import os
import sys
import platform
from dataclasses import dataclass
from typing import List, Tuple, Dict, Callable, Optional
from logging import getLogger, StreamHandler, Formatter

logger = getLogger(__name__)
# stdout
logger.addHandler(StreamHandler(sys.stdout))
logger.setLevel("INFO")
# format
formatter = Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger.handlers[0].setFormatter(formatter)


# ======================
# 配置常量
# ======================

DEFAULT_INSTALL_DIR = "~/pfbin"
VERSIONS = {
    "node": "20.14.0",
    "nvim": "0.10.0",
    "gh": "2.50.0",
    "lazygit": "0.42.0",
}

# ======================
# 数据类定义
# ======================


@dataclass
class SystemInfo:
    os_type: str  # linux/mac
    arch: str  # x86_64/arm64
    packager: str  # apt/yum/pacman/brew
    update_cmd: str


@dataclass
class PackageInfo:
    name: str
    packages: List[str]
    skip_platforms: List[str] = None
    skip_packagers: List[str] = None


@dataclass
class CurlPackage:
    name: str
    url_template: str
    post_install: Callable
    file_type: str = "tar.gz"


# ======================
# 系统检测逻辑
# ======================


class SystemDetector:
    @staticmethod
    def detect() -> SystemInfo:
        os_type = platform.system().lower()
        arch = platform.machine().lower()

        if os_type == "darwin":
            return SystemInfo(
                os_type="mac", arch="arm64" if arch == "arm64" else "x86_64", packager="brew", update_cmd="brew update"
            )

        return SystemInfo(os_type="linux", arch=arch, **SystemDetector._detect_linux_packager())

    @staticmethod
    def _detect_linux_packager() -> dict:
        packager_map = {
            "/usr/bin/apt": ("apt", "apt update -y"),
            "/usr/bin/yum": ("yum", "yum update -y"),
            "/usr/bin/pacman": ("pacman", "pacman -Syu --noconfirm"),
        }

        for path, (pkg, cmd) in packager_map.items():
            if os.path.exists(path):
                return {"packager": pkg, "update_cmd": cmd}

        raise RuntimeError("Unsupported Linux package manager")


# ======================
# 包管理逻辑
# ======================


class PackageManager:
    INSTALL_CMDS = {
        "apt": "DEBIAN_FRONTEND=noninteractive apt-get install -y",
        "yum": "yum install -y",
        "pacman": "pacman -Sy --noconfirm",
        "brew": "brew install ",
    }

    def __init__(self, system_info: SystemInfo):
        self.sys = system_info

    def generate_install_commands(self, packages: List[str]) -> List[str]:
        if self.sys.packager not in self.INSTALL_CMDS:
            raise ValueError(f"Unsupported packager: {self.sys.packager}")

        base_cmd = self.INSTALL_CMDS[self.sys.packager]
        logger.info(f"Using {self.sys.packager} to install packages: {packages}")
        return [f"{base_cmd} {pkg}" for pkg in packages]


# ======================
# 通用安装逻辑
# ======================


class InstallerConfig:
    def __init__(self):
        self.install_dir = os.path.expanduser(DEFAULT_INSTALL_DIR)
        self.system_packages = [
            PackageInfo("git", ["git"]),
            PackageInfo("curl", ["curl"]),
            PackageInfo("wget", ["wget"]),
            PackageInfo("lua", ["lua5.4"], skip_packagers=["apt"]),
            PackageInfo("openssh", ["openssh-server"], skip_platforms=["mac"]),
            PackageInfo("zsh", ["zsh"]),
            PackageInfo("tmux", ["tmux"]),
            PackageInfo("ripgrep", ["ripgrep"]),
            PackageInfo("fzf", ["fzf"]),
        ]

        self.curl_packages = [
            CurlPackage(
                name="node",
                url_template=("https://nodejs.org/dist/{version}/" "node-{version}-{system}-{arch}.tar.xz"),
                post_install=self._node_post_install,
            ),
            # 其他包配置类似...
        ]

    def _node_post_install(self, dest: str) -> List[str]:
        return [
            f"mkdir -p {self.install_dir}/node",
            f"tar -xf {dest} -C {self.install_dir}/node --strip-components=1",
            self._add_to_path(f"{self.install_dir}/node/bin"),
        ]

    def _add_to_path(self, path: str) -> str:
        return f'echo "export PATH=\\$PATH:{path}" >> ~/.bashrc >> ~/.zshrc'


# ======================
# 主安装流程
# ======================


class MainInstaller:
    def __init__(self):
        self.sys = SystemDetector.detect()
        self.config = InstallerConfig()
        self.pkg_manager = PackageManager(self.sys)
        self.commands: List[str] = []

    def run(self):
        try:
            self._add_system_update()
            self._install_system_packages()
            self._install_curl_packages()
            self._run_post_install()
            self._show_commands()
        except Exception as e:
            print(f"Installation failed: {str(e)}")
            exit(1)

    def _add_system_update(self):
        self.commands.append(self.sys.update_cmd)

    def _install_system_packages(self):
        for pkg_info in self.config.system_packages:
            if self._should_skip(pkg_info):
                continue

            cmds = self.pkg_manager.generate_install_commands(pkg_info.packages)
            self.commands.extend(cmds)

    def _should_skip(self, pkg_info: PackageInfo) -> bool:
        if pkg_info.skip_platforms and self.sys.os_type in pkg_info.skip_platforms:
            logger.info(f"Skipping {pkg_info.name} installation on {self.sys.os_type}")
            return True
        if pkg_info.skip_packagers and self.sys.packager in pkg_info.skip_packagers:
            logger.info(f"Skipping {pkg_info.name} installation with {self.sys.packager}")
            return True
        if any(self._already_installed(pkg) for pkg in pkg_info.packages):
            logger.info(f"{pkg_info.name} is already installed, skipping installation")
            return True
        return False

    def _already_installed(self, pkg: str) -> bool:
        return os.system(f"which {pkg} > /dev/null") == 0

    def _install_curl_packages(self):
        for pkg in self.config.curl_packages:
            url = self._format_url(pkg)
            dest = f"/tmp/{pkg.name}.{pkg.file_type}"
            self.commands.extend([f"curl -L {url} -o {dest}", *pkg.post_install(dest)])

    def _format_url(self, pkg: CurlPackage) -> str:
        system_str = "darwin" if self.sys.os_type == "mac" else "linux"
        return pkg.url_template.format(
            version=VERSIONS[pkg.name], system=system_str, arch=self.sys.arch, os_type=self.sys.os_type
        )

    def _run_post_install(self):
        self.commands.extend(
            [
                "git config --global user.name 'PannenetsF'",
                "git config --global user.email 'pannenets.f@foxmail.com'",
                "git config --global core.editor nvim",
            ]
        )

    def _show_commands(self):
        for cmd in self.commands:
            # exec with the shell
            os.system(cmd)


if __name__ == "__main__":
    installer = MainInstaller()
    installer.run()
