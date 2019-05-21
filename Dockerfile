FROM ubuntu:16.04

# MAINTAINER nontan <nontan@sfc.wide.ad.jp>
LABEL maintainer="nontan@sfc.wide.ad.jp"

WORKDIR /root/work

# TexLiveの依存関係ライブラリをインストール
RUN apt-get -q update
RUN apt-get -qy install wget build-essential libfontconfig1
# RUN rm -rf /var/lib/apt/lists/*

# TexLiveのミラーサイトからパッケージをダウンロードしてきて解凍
# WARNING: このリンクは常に最新版のTexLiveが配信されるのでbuildするごとにバージョンが変わる可能性がある．
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O /tmp/install-tl-unx.tar.gz
RUN mkdir /tmp/install-tl-unx
RUN tar -xvf /tmp/install-tl-unx.tar.gz -C /tmp/install-tl-unx --strip-components=1

# インストールの設定をbasic版に変更
RUN echo "selected_scheme scheme-basic" >> /tmp/install-tl-unx/texlive.profile
# TexLiveのインストール開始
RUN /tmp/install-tl-unx/install-tl -profile /tmp/install-tl-unx/texlive.profile
# TexLiveのインストールバージョンを調べて，PATHを通せるようにシンボリックリンクを張っておく
RUN TEX_LIVE_VERSION=$(/tmp/install-tl-unx/install-tl --version | tail -n +2 | awk '{print $5}'); \
    ln -s "/usr/local/texlive/${TEX_LIVE_VERSION}" /usr/local/texlive/latest
ENV PATH="/usr/local/texlive/latest/bin/x86_64-linux:${PATH}"

# Install Packages
RUN tlmgr install latexmk
COPY ./app/config/.latexmkrc /root/.latexmkrc
# 2カラムの設定に必要なパッケージのインストール
RUN tlmgr install multirow
# 日本語対応パッケージのインストール
RUN tlmgr install collection-langjapanese
# フォントパッケージのインストール
RUN tlmgr install collection-fontsrecommended
RUN tlmgr install collection-fontutils

# References
# - https://github.com/blang/latex-docker
# - https://github.com/Paperist/docker-alpine-texlive-ja/blob/master/Dockerfile
