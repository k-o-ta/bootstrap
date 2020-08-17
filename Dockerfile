FROM ubuntu

RUN apt-get update -qq
# ロケール
RUN  apt-get install -y locales locales-all \
    && locale-gen ja_JP.UTF-8
RUN apt-get install -y language-pack-ja


RUN apt-get install -y --no-install-recommends  make software-properties-common

# zsh
RUN apt-get install -y zsh sed
RUN zsh
ENV SHELL /usr/bin/zsh
RUN sed -i.bak "s|$HOME:|$HOME:$SHELL|" /etc/passwd

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
RUN update-locale LANGUAGE="ja_JP.UTF-8"

# ユーザー作成とsudo権限
ENV USER k-ota
ENV HOME /home/$USER

RUN apt-get install -y --no-install-recommends sudo
RUN useradd -m -p koji $USER -G sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
WORKDIR $HOME
