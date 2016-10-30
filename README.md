# Renew

This is a universal project generator that grow out of Nebo #15 requirements:

  - We use micro-service architecture, so we used to have many projects that start with a same boilerplate that differs by included features.
  - We want our code to have same style.
  - We want our API responses [to have same logic](http://docs.apimanifest.apiary.io/#) in all our products.
  - And we want to have it covered with tests.
  - We follow [the twelve-factor methodology](https://12factor.net/), especially we are trying to use environment variables in all application configurations. This allows us to build Docker containers and use them in different environments. In this way we can be sure that everything works on production in a same way as in environment where we test our products.
  - We use Docker since it allows to deploy binaries and run acceptance/performance tests against them in a release cycle.
  - We use Travis-CI to run tests and to build Docker containers.
  - We use Kubernetes clusters with many docker containers inside.
  - We want Docker containers be as small as possible, Apline Linux is the best for it.
  - We use Ecto and Phoenix (only in places where we need them), also we use RabbitMQ to guarantee message processing.

So it includes:

  - [Distillery](https://github.com/bitwalker/distillery) release manager.
  - [Confex](https://github.com/nebo15/confex) environment variables helper.
  - [Ecto](https://github.com/elixir-ecto/ecto) database wrapper with PostreSQL and MySQL adapters.
  - [Phoenix Framework](http://phoenixframework.org/).
  - [Multiverse](http://github.com/Nebo15/multiverse/) response compatibility layers.
  - [RBMQ](https://github.com/Nebo15/rbmq) RabbitMQ wrapper.
  - [EView](https://github.com/Nebo15/eview) Phoenix response and views wrapper.
  - Code Coverage, Analysis and Benchmarking tools:

    - [Benchfella](https://github.com/alco/benchfella) - Microbenchmarking tool.
    - [ExCoveralls](https://github.com/parroty/excoveralls) - Coverage report tool with coveralls.io integration.
    - [Dogma](https://github.com/lpil/dogma) - A code style linter.
    - [Credo](https://github.com/rrrene/credo) - A static code analysis tool with a focus on code consistency and teaching.

  - Setup for [Travis-CI](http://travis-ci.org/) Continuous Integration. And many scripts that makes simpler to work with it.
  - Pre-Commit hooks to keep code clean.
  - Docker container configuration and helper scripts.


## Installation

Install this package globally:

  ```
  mix archive.install https://github.com/Nebo15/renew/releases/download/0.13.0/renew.ez
  ```

## Usage

Usage is very similar to `mix new`, but with many additional feature flags:

  - `docker` - include Docker setup.
  - `ci` - include Travis-Ci setup.
  - `ecto` and `ecto_db` - include Ecto adapter.
  - `amqp` - include RBMQ setup.
  - `phoenix` - include Phoenix setup.

Run `renew` mix task to create new projects:

  ```
  mix renew myapp --ecto --ci --docker --phoenix
  ```

You can get more info in [renew mix task](https://github.com/Nebo15/renew/blob/master/lib/mix/renew.ex#L10).

### Docker Helpers

`Dockerfile` needs enhancements, so take look in it's source. Sometimes you need to expose some ports to talk to a container, and change `CMD` of your application.

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

Another one is `./bin/start.sh` that will run your app in detached mode.

### Environment variables

Use `${ENV_VAR}` inside `config/config.exs` since Distillery is configured to replace OS vars on each run of application.

  ```
  config :myapp, :mykey,
    db_user: "${DB_USER}"
  ```

When configuring your code you can also use Confex and `{:system, VAR_NAME, default_value}` tuples:

  ```
  config :myapp, :mykey,
    somevar: {:system, "MY_VAR_NAME", "default"}
  ```

  and read it later:

  ```
  Confex.get_map(:myapp, :mykey)
  ```

Later you can start Docker container passing `.env` file to set appropriate configuration of your application:

  ```
  $ docker run --env-file .env [rest..]
  ```

### Migrations

Whenever you make a release for your app you can't use mix anymore, but you still want to be able to run migrations. For this cases we include migrator module. [This post](http://blog.plataformatec.com.br/2016/04/running-migration-in-an-exrm-release/) tells how to run migration without mix.

Your migrations will be preserved within container in `./priv/repo` folder.

To run a migration set `APP_RUN_SEED=true` and `APP_MIGRATE=true` in your environment.

## Useful links

- https://robots.thoughtbot.com/deploying-elixir-to-aws-elastic-beanstalk-with-docker
- http://blog.plataformatec.com.br/2016/05/how-to-config-environment-variables-with-elixir-and-exrm/
- https://github.com/bitwalker/distillery/blob/master/docs/Runtime%20Configuration.md
- [Deploying Elixir and Phoenix applications using Docker and Exrm](https://gist.github.com/brienw/85db445a0c3976d323b859b1cdccef9a)

## Thanks

- [bitwalker](https://github.com/bitwalker) for his Docker container script and for being proactive while helping in Distillery issues.
