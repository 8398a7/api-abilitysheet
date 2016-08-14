FROM crystallang/crystal

ENV HOME /root

ADD ./public     $HOME/public
ADD ./src        $HOME/src
ADD ./shard.yml  $HOME/shard.yml
ADD ./shard.lock $HOME/shard.lock
ADD ./.env       $HOME/.env

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    cd $HOME && \
    shards && \
    cd $HOME && \
    crystal compile --release src/app.cr && \
    sudo apt-get update && \
    sudo apt-get install wget && \
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - && \
    sudo apt-get update && \
    sudo apt-get install postgresql postgresql-contrib -y

EXPOSE 8080
CMD cd /$HOME && \
    ./app

# docker build -t crystal .
# docker run -d -p 8080:8080 --name=api-abilitysheet crystal
# docker exec -it api-abilitysheet bash
