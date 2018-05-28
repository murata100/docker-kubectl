FROM bash:4
RUN apk --no-cache add gettext ca-certificates openssl \
    && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 -O /usr/local/bin/dumb-init \
    && wget https://storage.googleapis.com/kubernetes-release/release/v1.9.7/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod a+x /usr/local/bin/kubectl /usr/local/bin/dumb-init \
    && apk --no-cache del ca-certificates openssl

RUN apk --no-cache add git ncurses bash-completion
RUN mkdir /opt && cd /opt && git clone https://github.com/ahmetb/kubectx && \
  ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
  ln -s /opt/kubectx/kubens /usr/local/bin/kubens

RUN echo "source <(kubectl completion bash)" >> ~/.bashrc
RUN echo "source /etc/profile" >> ~/.bashrc

ENTRYPOINT ["/usr/local/bin/dumb-init","--","/usr/local/bin/docker-entrypoint.sh"]
CMD ["bash"]
