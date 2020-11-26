FROM archlinux
MAINTAINER obed.n.munoz@gmail.com


# Common Dev Tools
RUN pacman -Syu emacs-nox tmux git --noconfirm

# Yaourt
RUN pacman --noconfirm -S sudo base-devel
RUN chmod 640 /etc/sudoers && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && chmod 440 /etc/sudoers && useradd -m -p123123 -G wheel yaourt
RUN sudo -u yaourt rm -rf /tmp/package-query && \
    sudo -u yaourt rm -rf /tmp/yaourt && \
    cd /tmp && \
    sudo -u yaourt git clone https://aur.archlinux.org/package-query.git && \
    cd /tmp/package-query && \
    yes | sudo -u yaourt makepkg -si && \
    cd .. && \
    sudo -u yaourt git clone https://aur.archlinux.org/yaourt.git && \
    cd /tmp/yaourt && \
    yes | sudo -u yaourt makepkg -si && \
    cd .. && \
    echo 'EXPORT=2' >> /etc/yaourtrc && \
    sudo -u yaourt yaourt --version