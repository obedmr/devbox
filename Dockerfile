FROM archlinux
MAINTAINER obed.n.munoz@gmail.com

# Common Dev Tools
RUN pacman -Syu emacs-nox tmux git zsh wget sudo base-devel --noconfirm

# Yaourt
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

# Shell
RUN sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
CMD ["/usr/bin/zsh"]

# dotfiles
RUN git clone https://github.com/obedmr/dotfiles.git $HOME/dotfiles ; \
    echo "source $HOME/.extras" >> $HOME/.zshrc;  \
    ln -s dotfiles/tmux/.tmux.conf $HOME/; \
    echo "export EDITOR=emacs" >> $HOME/.extras
