FROM python:3.7
# FROM mcr.microsoft.com/vscode/devcontainers/python:3.6
ARG USERNAME="vscode"
ARG USER_UID=9999
ARG USER_GID=$USER_UID
ARG PASSWORD="1111"
ARG WORKSPACEFOLDER="project"
ARG GIT_USER="vscode"
ARG GIT_EMAIL="vscode@vscode.vscode"
ARG DB_PORT="5432"
#/etc/postgresql/12/main
# postgresql.conf

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -p $(openssl passwd -crypt $PASSWORD) \
    && mkdir /opt/${WORKSPACEFOLDER}\
    && chown ${USERNAME}:${USERNAME} /opt/${WORKSPACEFOLDER}\
    && apt-get -y update \
    && apt-get install -y sudo \
    && apt-get install git\
    && apt-get -y install libxml2-dev libxslt1-dev libldap2-dev\
        libsasl2-dev libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev\
        zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev\
        libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev\
    && apt-get -y install postgresql-13\
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME\
    && mkdir /home/$USERNAME/.ssh\
    && echo "[user]\n"\
        "\tname = $GIT_USER\n"\
        "\temail = $GIT_EMAIL\n"\
        >> /home/$USERNAME/.gitconfig\
    && echo "port = $DB_PORT" >> /etc/postgresql/13/main/postgresql.conf\
    && chown ${USERNAME}:${USERNAME} /home/$USERNAME/.ssh\
    && sudo service postgresql start\
    && sudo -u postgres createuser --superuser $USERNAME\
    && sudo -u postgres psql -c "alter role $USERNAME with password '1111'"

# COPY .devcontainer/dockerrun.sh /home/${USERNAME}/
# RUN bash /home/${USERNAME}/dockerrun.sh  $USERNAME $PASSWORD $WORKSPACEFOLDER $USER_UID $USER_GID

COPY .ssh  /home/${USERNAME}/.ssh/
USER $USERNAME