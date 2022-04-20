# docker-template_ubuntu
基于 ubuntu 构建 Docker 镜像的模板  
利用此模板可快速构建基于 ubuntu 操作系统的容器镜像。


## 1. 定制安装列表
修改文件CUSTOM_INFO中的变量：

| 变量             | 描述                		     |
|-----------------|-----------------------------|
| **IMGNAME**		  | 镜像名称，默认为 `test-u`		  |
| **VERSION**		  | 镜像版本，默认为 `latest `		|
| **PKGS**		    | 要安装的软件包列表 (示例安装vim)  	|
| **maintainer**	| 镜像维护者信息[可选]           |
| **ENTRY**		    | 镜像入口程序，默认为 `/bin/bash`|


## 2. 构建docker image
在当前目录执行：

> **./scripts/build.sh**


会创建名称为 **${USERNAME}/${IMGNAME}:${VERSION}** 的docker image  
例如：用户alice创建的默认image名称为 alice/test-u:latest

## 3. 安装脚本

构建完毕后，在当前目录执行：

> **[FUNC_ALIAS=alias] ./scripts/install.sh [TargetPath]**

将生成脚本 `${TARGET_PATH}/docker_env/${ENTRY}_${IMGNAME}_env`  
**TargetPath** 的默认值为： `${HOME}/.local`  
如不指定，则生成的脚本为：`${HOME}/.local/docker_env/vim_test-u_env`  
如果安装时指定了**FUNC_ALIAS=alias**，则生成的脚本为：``${TARGET_PATH}/docker_env/alias_test-u_env``


## 4. 使用方法
对于用户alice, 参考安装脚本提示：
<pre>First, exec:
    source /home/alice/.local/docker_env/vim_test-u_env
Then, use:
    docker_vim [arg1]...</pre>

如果安装时指定了**FUNC_ALIAS=alias**，则安装脚本提示：
<pre>First, exec:
    source /home/alice/.local/docker_env/alias_test-u_env
Then, use:
    docker_alias [arg1]...</pre>


如需永久生效，可将
>source /home/alice/.local/docker_env/vim_test-u_env

添加到${HOME}/.bashrc
