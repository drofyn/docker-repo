# Emlog Pro 自定义镜像

本目录包含定制版 Emlog Pro Web 容器的构建文件。该镜像采用 **Nginx + PHP 7.4 FPM** 单体架构，通过内存级的 **Unix Domain Socket** 进行内部通信，只对外暴露nginx的监听地址

## 架构特性

* **高性能 Socket 通信**：内部 Nginx 与 PHP-FPM 走 Unix Socket (`/var/run/php-fpm.sock`)，彻底抹去了容器内部对 TCP 9000 端口的依赖与暴露。
* **自定义监听绑核**：支持通过 `WEB_LISTEN` 环境变量控制容器内 Nginx 绑定的 IP 和端口（如 `127.0.0.1:80`），防止公网直接绕过宿主机反向代理直连。
* **预设伪静态等代码**: 镜像引入nginx做入口，除包装php-fpm通信外，就是构造了入口的静态文件等处理规则，屏蔽对外细节。
* **开箱即用自动释出**：镜像内自带源码压缩包。容器启动时会自动检查挂载目录，若为空则自动解压释放 Emlog Pro 全量源码文件并修正权限。
* **安全加固**：内置 PHP 安全配置，禁用 `exec`, `system`, `passthru`, `shell_exec` 等高危命令执行函数（保留 `curl` 以确保商店与激活功能正常）。
* **Alpine 极简体积**：基于 `php:8.2.35-fpm-alpine` 构建，集成必需的 GD、PDO_MySQL、mysqli、zip 扩展及 `ca-certificates` 根证书。

## 前置要求

在执行构建之前，请确保已将 Emlog Pro 的官方安装包下载并放置在当前构建目录下：
* 文件名必须为：`emlog_pro.zip`

## 环境变量 (Build & Runtime)

| 环境变量名 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `WEB_LISTEN` | `80` | 容器内 Nginx 监听的 IP 与端口（支持 `IP:Port` 或纯 `Port`） |

## 本地构建与推送指南

### 1. 构建本地镜像
```bash
docker build -t emlog-pro:latest .
```

### 2. 已构建的公共镜像
docker pull ghcr.io/drofyn/emlog-pro:latest # 基于emlog-pro 2.6.30构建

## 部署示例

### docker compose
[docker-compose.yml](./docker-compose.yml)

### 前置nginx代理
```nginx
server {
	listen 443 ssl;
	server_name your_domain;

    # ssl config ...

	location / {
		proxy_pass http://127.0.0.1:8080/;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```
