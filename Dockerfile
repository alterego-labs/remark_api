FROM elixir:1.2.3
MAINTAINER Sergey Gernyak <sergeg1990@gmail.com>

ENV MIX_ENV=prod

RUN apt-get update && apt-get install -y build-essential git-core

RUN mkdir -p /app

WORKDIR /app

COPY . ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get && mix deps.compile
RUN mix compile
RUN mix release

EXPOSE 8183

CMD ["rel/remark_api/bin/remark_api", "console"]
