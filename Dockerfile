#Elixir docker image
FROM ubuntu:16.04

MAINTAINER Philipe Cortez <philipesousacortez@gmail.com>

# Elixir requires UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#install essential tools
RUN apt-get -y update && apt-get -y install build-essential curl git python-setuptools ruby wget make sudo

# add alchemist user and grant super powers to him
RUN useradd -ms /bin/bash alchemist && adduser alchemist sudo
ADD /sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers

# change user and work dir
USER alchemist
WORKDIR /home/alchemist


#install latest erlang
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
 && sudo dpkg -i erlang-solutions_1.0_all.deb \
 && sudo apt-get update

# install latest elixir package
RUN sudo apt-get install -y elixir erlang-dev erlang-parsetools && rm erlang-solutions_1.0_all.deb

ENV PHOENIX_VERSION 1.1.4

# install the Phoenix Mix archive
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new-$PHOENIX_VERSION.ez

# install Node.js (>= 5.0.0) and NPM in order to satisfy brunch.io dependencies
# See http://www.phoenixframework.org/docs/installation#section-node-js-5-0-0-
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash - && sudo apt-get install -y nodejs