FROM elixir:1.5

# Compile elixir files for production
# ENV MIX_ENV prod
ENV MIX_ENV prod

RUN mkdir /app
WORKDIR /app

EXPOSE 4000
EXPOSE 4001

ADD . /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.1 
RUN mix deps.get
RUN mix compile


CMD ["mix","phx.server"]