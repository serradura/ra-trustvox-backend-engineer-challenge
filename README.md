# Complaints handler

This application provide some services to persist and fetch (To-do) complaints.

## Ruby version
> 2.6.0

## System dependencies
* Redis
* MongoDB
* For development:
  * [asdf](https://github.com/asdf-vm/asdf#installation)
  * [foreman](https://github.com/ddollar/foreman#installation)

## Configuration
* Install:
  1. [asdf](https://github.com/asdf-vm/asdf#installation)
  2. [foreman](https://github.com/ddollar/foreman#installation)
* Execute:
  1. `./bin/setup`
  2. `foreman start -f Procfile.dev`

## Database creation and initialization
Execute: `foreman start -f Procfile.dev`

## How to run the test suite
1. Open a terminal session and execute: `foreman start -f Procfile.dev`
2. Open a new terminal session and execute: `bundle exec rails test`

## Services (job queues, cache servers, search engines, etc.)

__Job queues:__ Sidekiq (via ActiveJob)

## Deployment instructions
> To-do

## Roadmap
- [x] Provides an easy way to setup the project (asdf + foreman).
- [x] Mount the `Rails API` and the `Sidekiq Admin` in config.ru.
- [x] Decouple the application in modules from the beginning. e.g: All entities/resources exists inside of `Complaints` namespace - Complaints:Document, Complaints::V1::CreateController.
- [x] Add a Restful resource to create complaints. e.g: `POST /complaints`
- [ ] Add a Restful resource to fetch complaints. e.g: `GET /complaints`
- [x] Add a Restful resource to fetch a single complaint. e.g: `GET /complaints/:id`
- [ ] Refactoring: Create a new branch to implementing a service layer to be used with the controllers.
- [ ] Add an API rate limiting/throttling. (Rack::Attack)
- [ ] Deploy: Setup the application to deploy it via Heroku.
- [ ] Add code quality tools. e.g: Rubocop, Code climate/Rubycritic.
  Look this example from my other project: https://github.com/serradura/backend-code-challenge#verifica%C3%A7%C3%A3o-da-sa%C3%BAde-do-projeto
