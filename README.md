# Renew

This module adds ```mix renew``` task that imports our base folder structure. Usage is very similar to `mix new` except custom enhancements that we used to do.

## What has changed?

We trying to have our projects consistent, so some other small changes are made:
- `.gitignore` will ignore release and editor specific files.
- `LICENSE.md` will also be generated, since we want to add it to all our repos.
- `mix.exs` will have appropriate structure for HEX package manager and `ex_doc` dependency.
- `.dockerignore` will make sure that no unnecessary scripts will be packaged into container.

### Deployment

The biggest addition is deployment tools that we use.

`mix.exs` will include [Distillery](https://github.com/bitwalker/distillery) as release management tool. It will be used in `Dockerfile` to build project into a Docker container.

`Dockerfile` needs enhancements, so take look in it's source. Usually you need to expose some ports to talk to a container, and change `ENTRYPOINT` of your application.

There are `./bin/build.sh` script that removes routine in building container for production.
  ```
  $ ./bin/build.sh
  [I] Building a Docker container 'myapp' from path '/Users/andrew/Projects/www/myapp'..
  Sending build context to Docker daemon 24.96 MB
  Step 1 : FROM trenpixster/elixir:1.3.2
   ---> e22fdfc62c5a
  ...
  Successfully built eae970501b13
  ```

### Environment variables

Use `${ENV_VAR}` inside `config/config.exs` since Distillery is configured to replace OS vars on each run of application.

  ```
  config :myapp, :myapp,
    db_user: "${DB_USER}"
  ```

Later you can start Docker container passing `.env` file to set appropriate configuration of your application:
  ```
  $ docker run --env-file .env [rest..]
  ```

### Testing and CI

We love TDD, so following dependencies are added by default:

  - [Benchfella](https://github.com/alco/benchfella) - Microbenchmarking tool.
  - [ExCoveralls](https://github.com/parroty/excoveralls) - Coverage report tool with coveralls.io integration.
  - [Dogma](https://github.com/lpil/dogma) - A code style linter.
  - [Credo](https://github.com/rrrene/credo) - A static code analysis tool with a focus on code consistency and teaching.

All this tools supplied with custom configuration.

Take look at [Travis-CI](https://travis-ci.org/). It will make sure that all tests passing on each commit and pull request.

### Migrations

Whenever you make a release for your app you can't use mix anymore, but you still want to be able to run migrations. For this cases we include migrator module. [This post](http://blog.plataformatec.com.br/2016/04/running-migration-in-an-exrm-release/) tells how to run migration without mix.

Your migrations will be preserved within container in `./repo` folder.

## Installation

Install this package globally:

  ```
  mix archive.install https://github.com/Nebo15/renew/releases/download/0.2.0/renew.ez
  ```

## Usage

You need to use `renew` task to create new projects:

  ```
  mix renew myapp
  ```

See [Mix.Tasks.New](http://elixir-lang.org/docs/stable/mix/Mix.Tasks.New.html) for additional documentation.

