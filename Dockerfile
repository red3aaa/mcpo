FROM python:3.11-slim

RUN useradd -ms /bin/bash mcp

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

USER mcp
RUN curl -fsSL https://bun.sh/install | bash

ENV BUN_INSTALL="/home/mcp/.bun"
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

USER root
RUN pip install --no-cache-dir mcpo uv

RUN mkdir -p /app/.cache/uv && chown -R mcp:mcp /app

ENV XDG_CACHE_HOME="/app/.cache"

USER mcp

EXPOSE 8000

CMD ["sh", "-c", "echo \"$MCPO_CONFIG_JSON\" > /app/config.json && mcpo --config /app/config.json"]
