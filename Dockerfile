# Stage 1: Build static site (optional if you already have dist/)
FROM node:22 AS builder
WORKDIR /app
# Install pnpm globally
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files and install dependencies
COPY package.json ./
COPY pnpm-lock.yaml ./
RUN pnpm install

# Copy source files and build
COPY . .
RUN pnpm build

# Stage 2: Serve with Caddy
FROM caddy:2.10.0-alpine
# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile
# Copy built files to Caddy's web root
COPY --from=builder /app/dist /usr/share/caddy

