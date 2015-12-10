FROM ubuntu:15.04
ENV CFLAGS="-Wno-error=unused-result" 
ENV CXXFLAGS="-Wno-error=unused-result"
ENV GOROOT=/opt/go
ENV GOPATH=/opt/app
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN mkdir /opt/app && mkdir /opt/app/bin && mkdir /opt/app/pkg && mkdir /opt/app/src

RUN mv /etc/apt/sources.list /etc/apt/sources.list.ori
RUN sed s/archive./br.archive./ /etc/apt/sources.list.ori > /etc/apt/sources.list
RUN apt-get update && apt-get install -y mercurial git gcc g++ make wget autotools-dev automake make cmake libtool libtool-bin pkg-config autoconf

RUN git clone https://github.com/jedisct1/libsodium.git && cd libsodium && git checkout 1.0.7
RUN cd libsodium && ./autogen.sh && ./configure && make && make install
RUN rm -r libsodium

RUN git clone https://github.com/zeromq/zeromq4-1.git && cd zeromq4-1 && git checkout v4.1.3
RUN cd zeromq4-1 && ./autogen.sh && ./configure && make && make install
RUN rm -r zeromq4-1

RUN git clone https://github.com/zeromq/czmq.git && cd czmq && git checkout v3.0.2
RUN cd czmq && ./autogen.sh && ./configure && make && make install
RUN rm -r czmq

RUN wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
RUN tar zxvf go1.5.2.linux-amd64.tar.gz -C /opt && rm go1.5.2.linux-amd64.tar.gz

RUN ldconfig