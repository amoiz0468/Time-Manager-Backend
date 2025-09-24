# TimeManagerApi


## Project Overview

TimeManagerApi is a platform-independent REST API for managing users, clocks, and working times. It is built with Elixir Phoenix and uses PostgreSQL as the database. There is no frontend; this is an API-only project.

## Getting Started

1. Install dependencies:
	```bash
	mix deps.get
	```
2. Create and migrate the database:
	```bash
	mix ecto.create
	mix ecto.migrate
	```
3. Start the Phoenix server:
	```bash
	mix phx.server
	```

The API will be available at [http://localhost:4000/api](http://localhost:4000/api)

## API Endpoints

### Users
- `GET    /api/users?email=XXX&username=YYY` — List users by email and/or username
- `GET    /api/users/:userID` — Get a user by ID
- `POST   /api/users` — Create a new user
- `PUT    /api/users/:userID` — Update a user
- `DELETE /api/users/:userID` — Delete a user

### Working Time
- `GET    /api/workingtimes/:userID?start=XXX&end=YYY` — List working times for a user in a date range
- `GET    /api/workingtimes/:userID/:id` — Get a specific working time by ID
- `POST   /api/workingtimes/:userID` — Create a new working time for a user
- `PUT    /api/workingtimes/:id` — Update a working time
- `DELETE /api/workingtimes/:id` — Delete a working time

### Clocks
- `GET    /api/clocks/:userID` — Get clocks for a user
- `POST   /api/clocks/:userID` — Clock in/out for a user

## Database Schemas

### users
| Field     | Type   | Constraints                |
|-----------|--------|---------------------------|
| username  | string | required, unique, not null|
| email     | string | required, unique, not null|

### clocks
| Field   | Type         | Constraints                |
|---------|--------------|---------------------------|
| time    | datetime     | required, not null        |
| status  | boolean      | required, not null        |
| user_id | references   | required, not null        |

### workingtimes
| Field   | Type         | Constraints                |
|---------|--------------|---------------------------|
| start   | datetime     | required, not null        |
| end     | datetime     | required, not null        |
| user_id | references   | required, not null        |

## Notes
- This project is API-only. No frontend is included.
- Test endpoints with Postman or similar tools.

## License
MIT
