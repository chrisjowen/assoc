FROM elixir:1.7

# Compile elixir files for production
# ENV MIX_ENV prod
ENV MIX_ENV prod

RUN mkdir /app
WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN  apt-get update && apt-get  -y upgrade && apt-get install -y npm

ADD . /app

WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.1 
RUN mix deps.get
RUN mix compile

WORKDIR /app/assets
RUN npm rebuild node-sass
RUN npm install && npm run deploy

EXPOSE 80
EXPOSE 4000

WORKDIR /app
RUN  mix compile && mix phx.digest


CMD ["mix","phx.server"]