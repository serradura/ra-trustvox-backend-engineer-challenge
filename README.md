# RA Trustvox - Backend Engineer Challenge

To achieve some of the [challenge goals](https://gist.github.com/cleytonmessias/6098d0747743620dfc58f977a8f1ded7),
this application provides services/resources to persist and fetch complaints.

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
- [x] Add a Restful resource to fetch complaints. e.g: `GET /complaints`
- [x] Add a Restful resource to fetch a single complaint. e.g: `GET /complaints/:id`
- [ ] Add code quality tools. e.g: Rubocop, Code Rubycritic...
- [ ] Refactoring: Create a new branch to implement a service layer to be used with the controllers.
- [ ] Deploy: Setup the application to deploy it via Heroku
- [ ] Add an API rate limiting/throttling. (Rack::Attack)
