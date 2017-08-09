FROM ubuntu:16.04
ENV CFLAGS="-Wno-error=unused-result" 
ENV CXXFLAGS="-Wno-error=unused-result"
ENV GOROOT=/usr/local/go
ENV GOPATH=/opt/app
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN mkdir /opt/app && mkdir /opt/app/bin && mkdir /opt/app/pkg && mkdir /opt/app/src && \
    mv /etc/apt/sources.list /etc/apt/sources.list.ori && \
    sed s/archive./br.archive./ /etc/apt/sources.list.ori > /etc/apt/sources.list && \
    apt-get update && apt-get install -y mercurial git gcc g++ make wget autotools-dev automake make cmake libtool libtool-bin pkg-config autoconf && \
    git clone https://github.com/jedisct1/libsodium.git && cd libsodium && git checkout 1.0.7 && \
    ./autogen.sh && ./configure && make && make install && cd ../ && \
    rm -r libsodium && \
    git clone https://github.com/zeromq/zeromq4-1.git && cd zeromq4-1 && git checkout v4.1.3 && \
    ./autogen.sh && ./configure && make && make install && cd ../ && \
    rm -r zeromq4-1 && \
    git clone https://github.com/zeromq/czmq.git && cd czmq && git checkout v3.0.2 && \
    ./autogen.sh && ./configure && make && make install && cd ../ && \
    rm -r czmq && \
    wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
    tar zxvf go1.8.3.linux-amd64.tar.gz -C /usr/local && rm go1.8.3.linux-amd64.tar.gz && \
    ldconfig