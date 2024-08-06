FROM debian:latest

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list &&     sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y  build-essential g++ libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev python-is-python3

RUN apt-get install -y nodejs  npm

RUN apt-get install -y yarn

RUN yarn config set registry https://registry.npmmirror.com || true

RUN apt-get install -y git  openjdk-17-jdk maven

RUN apt-get install -y curl wget tzdata

RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&     dpkg-reconfigure --frontend noninteractive tzdata

# 安装 Node.js v20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN apt-get remove yarn 

# 安装 Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN yarn config set registry https://registry.npmmirror.com

# 配置 Yarn 增加超时时间
RUN yarn config set network-timeout 600000

# 设置工作目录
WORKDIR /workspace

# 复制 VSCode 源码到工作目录
COPY . .

# 使用 Yarn 安装依赖
RUN yarn  --verbose
