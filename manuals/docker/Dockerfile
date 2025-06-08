FROM riscv64/ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    tmux git neofetch \
    locales language-pack-ru \
    build-essential vim \
    qemu-user-static

ARG USR=root
WORKDIR /home/${USR}/

ARG LOCALE=ru_RU.UTF-8
ENV LANG=${LOCALE}
ENV LANGUAGE=${LOCALE}
ENV LCC_LANG=${LOCALE}
ENV LCC_ALL=${LOCALE}
RUN locale-gen ${LOCALE} && dpkg-reconfigure locales && \
    cd /home/${USR} && \
    echo -e "export LANG=${LOCALE}\nexport LANGUAGE=${LOCALE}" > .bash_profile && \
    echo -e "export LC_LANG=${LOCALE}\nexport LC_ALL=${LOCALE}" >> .bash_profile && \
    echo "source ~/.bash_profile" >> .bashrc

CMD ["/bin/bash"]
