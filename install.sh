#!/bin/bash

camelcase=$(grep defmodule mix.exs|perl -F/[\\s\.]+/ -e 'print$F[1]');
snakecase=$(grep -h -A5 "def project" mix.exs|grep app:|perl -F/[:,\\s]+/ -e 'print$F[2]');

echo "Using $camelcase ($snakecase) for app name. Press [Ctrl]+[C] if this is not right."
read -st5

curl https://codeload.github.com/dom111/phoenix-template/zip/main -o template.zip
unzip template.zip
rm template.zip

for file in config docker .env.dist docker-compose.yml Makefile; do
  if [ -e $file ]; then
    if [ -e $file.bak ]; then
      echo "Unable to back up $file, aborting. Please remove $file.bak to proceed." >&2
      exit 1;
    fi

    mv $file{,.bak}
  fi

  cp -r phoenix-template-main/$file .
done

rm -rf phoenix-template-main

perl -pi -e "s/MyApp/$camelcase/g;s/my_app/$snakecase/g" config/*

echo "Now run:
    make up

to build your app and see it running on localhost:4000.
";
