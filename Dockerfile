FROM node:latest

ARG ETHERPAD_PLUGINS="ep_aa_file_menu_toolbar ep_align ep_author_neat ep_etherpad-lite ep_pad-lister ep_set_title_on_pad ep_small_list ep_comments_page"


ENV ETHERPAD_VERSION 1.8.3


RUN apt-get update && \
    apt-get install -y curl unzip npm default-mysql-client 

WORKDIR /opt/

RUN curl -SL \
    https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.zip \
    > etherpad.zip && unzip etherpad && rm etherpad.zip && \
    mv etherpad-lite-${ETHERPAD_VERSION} etherpad-lite

WORKDIR etherpad-lite

RUN bin/installDeps.sh && rm settings.json
ADD assets /


RUN sed -i 's/^node/exec\ node/' bin/run.sh


VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

RUN for PLUGIN_NAME in ${ETHERPAD_PLUGINS}; do npm install "${PLUGIN_NAME}"; done


EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]

