# archiso-kde
Build an Arch Linux Live CD with a Chinese environment KDE desktop.

# 构建中文环境的KDE桌面的Arch Linux Live CD

本文档介绍了如何使用 `custom_airootfs.sh` 脚本来构建一个带有中文环境的KDE桌面的Arch Linux Live CD。

## 脚本说明

`custom_airootfs.sh` 脚本的主要功能包括：

1. **设置中文环境**：
    - 启用中文语言支持 (`zh_CN.UTF-8`)，并生成相应的本地化文件。
    - 设置系统语言为中文。

2. **创建自动登录用户**：
    - 创建用户名为 `arch`，密码为 `arch` 的用户。
    - 配置 SDDM 和 tty1 自动登录。

3. **启用必要服务**：
    - 启用 `sddm`、`NetworkManager` 和 `bluetooth` 服务。

4. **配置 sudo 权限**：
    - 为 `arch` 用户设置免密码sudo权限。

5. **设置时区**：
    - 将系统时区设置为上海，并更新硬件时钟。

6. **配置 SDDM 主题**：
    - 将 SDDM 主题设置为 Breeze。

7. **配置输入法**：
    - 安装字体缓存并配置 Fcitx5 输入法。
    - 设置全局和用户级别的输入法环境变量和配置文件。

7. **移除多余locale**：
    - 通过AUR构建localepurge软件包。
    - 按照 `pacman.conf` 末尾的说明构建本地仓库。

## 安装步骤

1. 下载Release的压缩包并解压。

    ```bash    
    sudo tar -xzvf archlive.tar.zst -C path/to/temp
    ```

2. 进入解压后的目录，构建镜像：

    ```bash
    cd archlive
    mkdir work
    sudo mkarchiso -v -w work .
    ```

构建完成后，生成的ISO文件将在 `out` 目录中。

## 使用

将生成的ISO文件刻录到U盘或者虚拟机中启动，即可体验带有中文环境的KDE桌面的Arch Linux。

