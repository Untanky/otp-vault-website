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

LABEL org.opencontainers.image.created="2025-08-11T12:00:00Z" \
      org.opencontainers.image.authors="Lukas Grimm" \
      org.opencontainers.image.url="otpvault.app" \
      org.opencontainers.image.source="https://github.com/untanky/otp-vault-website" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.revision="a1b2c3d4" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.ref.name="latest" \
      org.opencontainers.image.title="OTP Vault Website" \
      org.opencontainers.image.description="Container image hosting OTP Vault website with Caddy"
# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile
# Copy built files to Caddy's web root
COPY --from=builder /app/dist /usr/share/caddy

