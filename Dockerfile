# Dev-mode Dockerfile with code reloading
FROM elixir:1.16-alpine
RUN apk add --no-cache build-base git inotify-tools nodejs npm postgresql-client bash
WORKDIR /app

ENV MIX_ENV=dev

# Install hex/rebar
RUN mix do local.hex --force, local.rebar --force

# Cache deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get

# Optional JS assets (none in this repo). If you later add assets/, uncomment:
# COPY assets assets
# RUN [ -f assets/package.json ] && npm install --prefix assets || true

# Copy source code (mounted at runtime too)
COPY . .

EXPOSE 4000
CMD ["sh", "-lc", "mix ecto.create && mix ecto.migrate && mix phx.server"]