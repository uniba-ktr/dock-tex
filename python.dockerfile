FROM python:slim
MAINTAINER Marcel Grossmann <whatever4711@gmail.com>

ENV dir /pytex
RUN apt-get update && \
    apt-get install -y \
    texlive-base \
    texlive-latex-extra \
    texlive-lang-german \
    gnuplot \
    latexmk \
    texlive-fonts-extra \
    #texlive-generic-extra \
    texlive-science && \
    pip install -U Pygments && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
