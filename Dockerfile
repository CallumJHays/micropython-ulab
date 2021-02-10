# use python 3.6 because it's the closest to the current version of micropython for intellisense purposes.
# Also it's not at EOL and very few development tools don't support it (unlike 3.5)
FROM python:3.6-buster

ARG PROJ_NAME=ulab
ARG DEV_USER_NAME=me
ARG DEV_USER_PASS=${DEV_USER_NAME}

RUN apt-get update && \
    apt-get install gcc zsh -y && \
    useradd --create-home -G sudo ${DEV_USER_NAME} && \
    # set password to '${DEV_USER_PASS}'
    echo "${DEV_USER_NAME}:${DEV_USER_PASS}" | chpasswd && \
    # sudo -u ${DEV_USER_NAME} chsh -s $(which zsh) && \
    rm -rf /var/lib/apt/lists/*

# makes '${DEV_USER_NAME}' the default user on login. This behaviour is duplicated via below:
USER ${DEV_USER_NAME}
WORKDIR /home/${DEV_USER_NAME}

# make zsh defualt shell
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# install pl10k theme
# RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

COPY --chown=${DEV_USER_NAME} . /workspaces/${PROJ_NAME}
RUN ln -s /workspaces/${PROJ_NAME} $HOME/${PROJ_NAME} && \
    pip install -r $HOME/${PROJ_NAME}/requirements.txt
WORKDIR $HOME/${PROJ_NAME}

# TODO: ESP-IDF & xtensa compiler
ENTRYPOINT ["zsh"]