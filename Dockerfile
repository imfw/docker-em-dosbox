FROM debian:jessie

RUN \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -y build-essential \
                     automake \
                     autoconf \
                     libsdl2-dev \
                     unzip \
                     wget \
                     cmake \
                     nodejs \
                     default-jre-headless \
                     git-core

WORKDIR /tmp/emsdk_portable

RUN \
  wget -O /tmp/emsdk-portable.tar.gz https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz \
  && tar xvzf /tmp/emsdk-portable.tar.gz -C /tmp \
  && ./emsdk update \
  && ./emsdk install latest

ENV PATH $PATH:/tmp/emsdk_portable
ENV PATH $PATH:/tmp/emsdk_portable/clang/fastcomp/build_master_64/bin
ENV PATH $PATH:/tmp/emsdk_portable/emscripten/master
ENV EMSCRIPTEN /tmp/emsdk_portable/emscripten/master


WORKDIR /em-dosbox

RUN \
  git clone https://github.com/dreamlayers/em-dosbox.git /em-dosbox \
  && ./autogen.sh \
  && emconfigure \
  && sed -i "s@^NODE_JS.*@NODE_JS = 'nodejs'\n@g" ~/.emscripten \
  && emconfigure ./configure --with-sdl2 \
  && make

EXPOSE 8000

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# VOLUME /html
# VOLUME /games 

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
