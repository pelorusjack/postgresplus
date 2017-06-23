FROM starefossen/pgrouting:latest

ENV PATH ~/.cargo/bin/:$PATH
ENV CARGO_HOME /cargo
ENV SRC_PATH /src


RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates curl git make gcc gcc-multilib postgresql-server-dev-$PG_MAJOR python-pip \
  && rm -rf /var/lib/apt/lists/* \
  && curl -sf https://static.rust-lang.org/rustup.sh -o rustup.sh \
  && bash rustup.sh --disable-sudo -y --verbose \
  && pip install pgxnclient \
  && cargo install rustfmt \
  && mkdir -p "$CARGO_HOME" \
  && pgxn install jsoncdc --unstable

WORKDIR $SRC_PATH

VOLUME $SRC_PATH

COPY postgres.sh /docker-entrypoint-initdb.d/
COPY createrepluser.sql /docker-entrypoint-initdb.d/
COPY mongooseim.sql /docker-entrypoint-initdb.d/

