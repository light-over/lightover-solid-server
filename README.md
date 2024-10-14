# Lightover Solid Server

This solid server is built on top of [Community Solid Server](https://github.com/CommunitySolidServer/CommunitySolidServer), with a few modifications:

## Modification
 - Lightover branding is applied to the various login screens
 - prompt=create support allows apps to go directly to the reigster screen

## Running Locally

```shell
npm start -- -f ../data
```

## Deploying the Server for Lightover

Clone this library:
```bash
git clone git@github.com:light-over/CommunitySolidServer.git
```

Modify `.env` to match the desired config. For example:

```
PROTOCOL=https
DOMAIN_NAME=pod.lightover.com
DATA_FOLDER=/folder/data/
```

Then run the following to setup the environment:
```bash
chmod +x certbot/init-letsencrypt.sh
docker compose run --rm certbot certbot/init-letsencrypt.sh yourdomain.com your-email@domain.com
```

Finally, run this command to deploy the container

```bash
docker compose up -d
```
