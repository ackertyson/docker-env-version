# docker-env-version

NPM `version` hook to update Docker `.env` file with package version (for use in
tagging Docker images, for example).

## INSTALLATION

`npm i --save-dev docker-env-version`

## USAGE

In `package.json` (shown with optional path to Docker `.env` file--default is `./`):

```
"name": "my-npm-app",
"scripts": {
  "version": "docker-env-version ../"
}
```

...and in `docker-compose.yaml` (note that environment variable is uppercase
PACKAGENAME_VERSION and all nonalphanumeric characters in PACKAGENAME will be
replaced with underscore):

```
services:
  myapp:
    build:
      context: myapp/
    image: "myapp:${MY_NPM_APP_VERSION}"
```

Project directory structure for this example is like:

```
myapp/
  dist/
  src/
  Dockerfile
  package.json
docker-compose.yaml
.env
```

...and in such an example, `docker-env-version` should be installed in `myapp`,
not in root Docker project (that might not be true in your case).
