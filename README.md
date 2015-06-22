Dockerfile for testing [Pagekit](http://www.pagekit.com/)

## With Docker Compose

```
docker-compose up
```

## Bare Docker

```
git clone https://github.com/jverdeyen/docker-pagekit.git pagekit
cd pagekit
docker build -t="pagekit" .
docker run --name="pagekittest" -p 80 -d pagekit
```

Get the port docker is using for http/80:

```
 docker port pagekittest 80
```

# Requirements

* Docker
* Docker Compose
* VirtualBox/boot2docker (on Mac OS X)