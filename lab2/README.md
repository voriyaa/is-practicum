# Лаба 2 — Docker

Приложение на Flask: `/health` отвечает 200, `/` считает посещения в PostgreSQL.

Все команды запускаются из папки `lab2`.

## Docker #1

```
docker build -t lab2-app:1.0 .
docker run -d -p 8080:8080 -e DB_HOST=localhost lab2-app:1.0
curl -i localhost:8080/health
```

## Docker #2

```
cp .env.example .env
docker compose up -d --build
docker compose ps
curl localhost/health
curl localhost/
```

Наружу открыт только nginx на 80 порту, база сидит в отдельной сети `backend`. Данные хранятся в томе `pgdata` и не пропадают после `docker compose down` (без `-v`).

## Загрузка образа в registry

```
docker login
./build_and_push.sh <username>/lab2-app 1.0
```

## Скрины

![containers](https://github.com/voriyaa/is-practicum/blob/lab2/lab2/screenshots/containers.jpg?raw=true)

![health](https://github.com/voriyaa/is-practicum/blob/lab2/lab2/screenshots/health.jpg?raw=true)
