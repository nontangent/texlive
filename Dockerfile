# Alpine Linux v3.9.4をベースのイメージとして指定
FROM alpine:3.9.4

# MAINTAINER nontan <nontan@sfc.wide.ad.jp>
LABEL maintainer="nontan@sfc.wide.ad.jp"

WORKDIR /root/work

# パッケージリストの更新
RUN apk update
# TeXLiveのインストールに必要なパッケージを取得
RUN apk add perl wget fontconfig-dev
# TeXLiveのインストーラーの解凍に必要なパッケージのインストール
RUN apk add xz tar

# 圧縮されたTeXLiveのインストーラーをダウンロードし，tmpディレクトリに保存
ADD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz /tmp/install-tl-unx.tar.gz
# インストーラーを解凍した際に配置するディレクトリを作成
RUN mkdir /tmp/install-tl-unx
# ダウンロードしたinstall-tl-unx.tar.gzを解凍
RUN tar -xvf /tmp/install-tl-unx.tar.gz -C /tmp/install-tl-unx --strip-components=1
# TeXLiveのインストール用の設定ファイルを作成
RUN echo "selected_scheme scheme-basic" >> /tmp/install-tl-unx/texlive.profile
# TeXLiveのインストール
RUN /tmp/install-tl-unx/install-tl -profile /tmp/install-tl-unx/texlive.profile
# TeXLiveのバージョンを取得しインストールディレクトリを特定し，latestの名称でシンボリックリンクを作成
RUN TEX_LIVE_VERSION=$(/tmp/install-tl-unx/install-tl --version | tail -n +2 | awk '{print $5}'); \
    ln -s "/usr/local/texlive/${TEX_LIVE_VERSION}" /usr/local/texlive/latest
# インストールしたTeXLiveへパスを通す
ENV PATH="/usr/local/texlive/latest/bin/x86_64-linuxmusl:${PATH}"

# TeXLive Package Managerを使用して必要なパッケージをインストール
# texファイルの自動コンパイルパッケージをインストール
RUN tlmgr install latexmk
# latexmkの設定ファイルをホストからイメージにコピー
COPY ./app/config/.latexmkrc /root/.latexmkrc
# 2カラムの設定に必要なパッケージのインストール
RUN tlmgr install multirow
# 日本語対応パッケージのインストール
RUN tlmgr install collection-langjapanese
# フォントパッケージのインストール
RUN tlmgr install collection-fontsrecommended
RUN tlmgr install collection-fontutils

# 不要なパッケージなどの削除(イメージの容量削減のため)
RUN apk del xz tar
RUN rm -rf /var/cache/apk/*
RUN rm -rf /tmp/*


# References
# - https://github.com/blang/latex-docker
# - https://github.com/Paperist/docker-alpine-texlive-ja/blob/master/Dockerfile
