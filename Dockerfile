FROM alpine:3.4
RUN \
apk add --update go git make gcc musl-dev && \
git clone --depth 1 https://github.com/ethereum/go-ethereum && \
(cd go-ethereum && make geth) && \
cp go-ethereum/build/bin/geth /geth && \
apk del go git make gcc musl-dev && \
rm -rf /go-ethereum && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENV MINERTHREADS 4
ENV ETHERBASE 0x007a8e4f6bcae701bd980c4f370292e63d913fdc
ENV EXTRADATA ASSETH

COPY testnet_genesis.json /root/
RUN /geth --datadir /root/ropsten init /root/testnet_genesis.json

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
