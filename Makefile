.env: docker/secrets/SECRET_KEY_BASE
	# ensure that all files written into volumes mapped into the dev container are owned by the current host user
	sed "s/DEV_UID=.*/DEV_UID=`id -u`/" .env.dist > .env
	sed -i "s/LIVE_VIEW_SIGNING_SALT=.*/LIVE_VIEW_SIGNING_SALT=`cat /dev/urandom | tr -dc '0-9A-Za-z' | fold -w 8 | head -n 1`/" .env

docker/secrets/SECRET_KEY_BASE:
	cat /dev/urandom | tr -dc ' -~' | fold -w 64 | head -n 1 > docker/secrets/SECRET_KEY_BASE

.PHONY: build-docker
build-docker: .env
	docker-compose build

assets/node_modules: deps
	docker-compose run --rm -w /opt/app/assets app npm install

priv/static/js/app.js: webpack
	# no-op

.PHONY: webpack
webpack: assets/node_modules
	docker-compose run --rm -w /opt/app/assets app sh -c '`npm bin`/webpack --mode=development'

.PHONY: watch
watch: assets/node_modules
	docker-compose run --rm -w /opt/app/assets app npm run watch

deps: build-docker
	docker-compose run --rm app mix deps.get

.PHONY: build
build: deps
	echo "Built successfully.";

build/ecto: deps
	docker-compose run --rm app mix ecto.create

.PHONY: up
up: webpack build/ecto
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: clean
clean: down
	if -e build/ecto; then
		docker-compose run --rm app mix ecto.drop
	fi

	rm -rf .npm _build assets/node_modules build deps docker/secrets/SECRET_KEY_BASE priv/static .env
