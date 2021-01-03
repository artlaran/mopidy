FROM debian:buster-slim

# install dependencys
RUN apt-get update \
    && apt-get install -y \
    dumb-init \
    wget \
    gnupg

# add mopidy repository + install mopidy
RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - \
    && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list \
    && apt-get update --fix-missing \
    && apt-get install -y mopidy

# needed for spotify extension
RUN apt-get install -y libspotify12 python3-spotify python3-pip

# install mopidy extensions
RUN python3 -m pip install \
    Mopidy-Spotify \
    Mopidy-MPD \
    Mopidy-TuneIn \
    Mopidy-Moped \
    Mopidy-Party \
    Mopidy-GMusic \
    Mopidy-Local \
    Mopidy-SoundCloud \
    Mopidy-YouTube \
    Mopidy-Iris

RUN set -ex \
    && mkdir -p /var/lib/mopidy/.config \
    && ln -s /config /var/lib/mopidy/.config/mopidy

# Default configuration.
COPY mopidy.conf /config/mopidy.conf

ENV HOME=/var/lib/mopidy
RUN set -ex \
    && usermod -G audio,sudo mopidy \
    && chown mopidy:audio -R $HOME \
    && chmod go+rwx -R $HOME

USER mopidy

EXPOSE 6600 6680 5555/udp

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["mopidy"]