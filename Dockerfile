# Dev-mode Dockerfile with code reloading
FROM elixir:1.16-alpine
RUN apk add --no-cache build-base git inotify-tools nodejs npm postgresql-client bash

# Fix for ARM64 SSL issues during build
RUN if [ "$(uname -m)" = "aarch64" ]; then \
      apk add --no-cache openssl && \
      mix local.hex --force --if-missing && \
      mix local.rebar --force --if-missing; \
    else \
      mix local.hex --force && \
      mix local.rebar --force; \
    fi

WORKDIR /app
ENV MIX_ENV=dev

# Cache deps - with architecture-specific handling
COPY mix.exs mix.lock ./
COPY config config

# Handle dependencies differently based on architecture
RUN if [ "$(uname -m)" = "aarch64" ]; then \
      # For ARM64, try with explicit SSL configuration
      ELIXIR_ERL_OPTIONS="+ssl_dist_optfile=/etc/ssl/erl_dist.config" mix deps.get || \
      # Fallback to HTTP if SSL fails
      HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get --only prod; \
    else \
      # For other architectures, proceed normally
      mix deps.get; \
    fi

# Optional JS assets (none in this repo). If you later add assets/, uncomment:
# COPY assets assets
# RUN [ -f assets/package.json ] && npm install --prefix assets || true

# Copy source code (mounted at runtime too)
COPY . .

EXPOSE 4000
CMD ["sh", "-lc", "mix ecto.create && mix ecto.migrate && mix phx.server"]