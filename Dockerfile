# Build stage
FROM node:18-alpine AS build

# Set current working directory
WORKDIR /community-server

# Copy the dockerfile's context's community server files
COPY . .

# Install and build the Solid community server (prepare script cannot run in wd)
RUN npm ci --unsafe-perm && npm run build

# Runtime stage
FROM node:18-alpine

# Install necessary tools
RUN apk add --no-cache bash gettext

# Add contact informations for questions about the container
LABEL maintainer="Solid Community Server Docker Image Maintainer <thomas.dupont@ugent.be>"

# Container config & data dir for volume sharing
RUN mkdir /config /data

# Set current directory
WORKDIR /community-server

# Copy runtime files from build stage
COPY --from=build /community-server/package.json .
COPY --from=build /community-server/config ./config
COPY --from=build /community-server/dist ./dist
COPY --from=build /community-server/node_modules ./node_modules
COPY --from=build /community-server/templates ./templates

COPY --from=build /community-server/docker/communitySolidServer/config-prod.json.template config/config-prod.json.template

# Set environment variables at runtime (handled by docker-compose)
ENV CSS_CONFIG=config/config-prod.json
ENV CSS_MAIN_MODULE_PATH=./

# Informs Docker that the container listens on the specified network port at runtime
EXPOSE 3000

# At runtime, envsubst is used to substitute environment variables
ENTRYPOINT [ "sh", "-c", "envsubst < config/config-prod.json.template > config/config-prod.json && node node_modules/@solid/community-server/bin/server.js" ]
