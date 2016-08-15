FROM ubuntu:xenial

WORKDIR /root
ENV CRENV_ROOT /usr/local/crenv
ENV PATH $CRENV_ROOT/bin:$CRENV_ROOT/shims:$PATH
ENV CRYSTAL_VERSION 0.18.7

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install software-properties-common -y
RUN \
      apt-add-repository ppa:git-core/ppa && \
      apt-get update && \
      apt-get install git -y
RUN \
      git clone https://github.com/pine/crenv.git $CRENV_ROOT && \
      mkdir $CRENV_ROOT/shims && \
      mkdir $CRENV_ROOT/versions && \
      mkdir $CRENV_ROOT/plugins && \
      git clone https://github.com/pine/crystal-build.git $CRENV_ROOT/plugins/crystal-build && \
      apt-get install -y \
        build-essential \
        curl \
        libbsd-dev \
        libedit-dev \
        libevent-core-2.0-5 \
        libevent-dev \
        libevent-extra-2.0-5 \
        libevent-openssl-2.0-5 \
        libevent-pthreads-2.0-5 \
        libgmp-dev \
        libgmpxx4ldbl \
        libpcl1-dev \
        libssl-dev \
        libxml2-dev \
        libyaml-dev \
        libreadline-dev \
        pkg-config && \
      crenv install $CRYSTAL_VERSION && \
      crenv global $CRYSTAL_VERSION && \
      crenv rehash
RUN apt-get install postgresql-client-9.5 -y

ADD ./public     ./public
ADD ./src        ./src
ADD ./shard.yml  ./shard.yml
ADD ./shard.lock ./shard.lock
ADD ./.env       ./.env

RUN \
      shards && \
      crystal build --release src/app.cr

CMD /bin/bash && ./app

# docker build -t abilitysheet .
# docker run -d -p 8080:8080 --name=api-abilitysheet abilitysheet
# docker exec -it api-abilitysheet bash
