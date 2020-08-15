FROM ubuntu

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends sudo make software-properties-common
RUN useradd -m  k-ota -G sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER k-ota
WORKDIR /home/k-ota
