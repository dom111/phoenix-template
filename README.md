# Elixir/Phoenix Skeleton

## What is this?

This is a simple project that allows you to use `docker-compose` to run your Phoenix app in a containerised environment,
and a `make` mechanism to allow you to manage these tasks. This means that Elixir, `mix`, `node` etc are all installed
within the container, rather than being on your machine.

## Requirements

- Docker
- `docker-compose`
- `make`
- A POSIX-compatible shell (Tested on Linux)

## Installation

To add this to your existing Phoenix project, merge in:

- `config` (remember to change the app references from `MyApp` (`my_app`)!)
- `docker`
- `.env.dist`
- `docker-compose.yml`
- `Makefile`

If you're brave and/or reckless, feel free to try the following:

```shell
curl https://raw.githubusercontent.com/dom111/phoenix-template/master/install.sh | bash
```

## Build

```shell
make up
```

## Other commands

```shell
make migrate # runs ecto migrations
make webpack # runs webpack build
make watch # runs webpack watch
```