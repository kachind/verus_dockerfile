FROM ubuntu

ENV HOST="na.luckpool.net"
ENV PORT=3960
ENV ADDRESS="RKAQ4vLCiTiVL8QzoiCw7Z6tZmMZ19aF2P"
ENV WORKER="KachInd"
ENV CPU=0

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git libboost-all-dev cmake
RUN apt-get install sudo 

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN sudo apt-get update

RUN sudo git clone https://github.com/veruscoin/nheqminer.git
WORKDIR /nheqminer/cpu_xenoncat/asm_linux/
RUN sh assemble.sh
WORKDIR /nheqminer
RUN mkdir build
WORKDIR /nheqminer/build
RUN cmake ../nheqminer
RUN make .j $(nproc)


RUN wget https://raw.githubusercontent.com/kachind/verus/master/start.sh
RUN sudo chmod +x start.sh

ENTRYPOINT ["sh", "-c", "sudo ./start.sh -h \"$HOST\" -p \"$PORT\" -a \"$ADDRESS\" -w \"$WORKER\" -t \"$THREADS\""]


