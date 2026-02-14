FROM ruby:3.4.8-slim-trixie

RUN apt-get update -qq && \
  apt-get install -y  --no-install-recommends build-essential default-libmysqlclient-dev vim && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . /usr/src/app

CMD ["bash"]
