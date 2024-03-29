FROM debian:jessie
MAINTAINER Marcel Grossmann <whatever4711@gmail.com>

ENV dir /src
RUN apt-get update && \
    apt-get install -y \
    make \
    git \
    texlive-base \
    texlive-latex-extra \
    texlive-lang-german \
    gnuplot \
    latexmk \
    texlive-math-extra \
    texlive-fonts-extra \
    texlive-generic-extra \
    texlive-science \
    texlive-publishers && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR ${dir}
