FROM debian:buster-slim

RUN apt-get update
RUN apt-get install -y wget gnupg

RUN wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
RUN apt-get update --fix-missing

RUN apt-get install -y build-essential python3-dev python3-pip
RUN apt-get install -y \
    python3-gst-1.0 \
    gir1.2-gstreamer-1.0 \
    gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools

# needed for spotify extension
RUN apt-get install -y libspotify12 python3-spotify

# install mopidy
RUN python3 -m pip install --upgrade mopidy

# install mopidy extensions
RUN python3 -m pip install Mopidy-Spotify
RUN python3 -m pip install Mopidy-MPD
RUN python3 -m pip install Mopidy-TuneIn
RUN python3 -m pip install Mopidy-Moped
RUN python3 -m pip install Mopidy-Party
RUN python3 -m pip install Mopidy-GMusic
RUN python3 -m pip install Mopidy-Local
RUN python3 -m pip install Mopidy-SoundCloud
RUN python3 -m pip install Mopidy-YouTube
RUN python3 -m pip install Mopidy-Iris

# install mopidy.conf and startup script
COPY mopidy.conf /root/.config/mopidy_default.conf
COPY mopidy.sh /usr/local/bin/mopidy.sh

RUN usermod -G audio,sudo mopidy
RUN chown mopidy:audio -R /usr/local/bin/mopidy.sh
RUN chmod go+rwx -R /usr/local/bin/mopidy.sh

EXPOSE 6600 6680
ENTRYPOINT ["/usr/local/bin/mopidy.sh"]