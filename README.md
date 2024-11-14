# mmq-api

A minimalistic JSON MQ API implementation for MariaDB based on @markus456/mariadb-api

## Endpoints

The current API consists of the following resource collection endpoints:

* `/v1/users`
* `/v1/user`
* `/v1/queues`
* `/v1/queue`
* `/v1/subscriptions`
* `/v1/subscription`
* `/v1/brokers`
* `/v1/broker`
* `/v1/directory`
* `/v1/self`
* `/v1/publish`
* `/v1/read_next`
* `/v1/read`
* `/v1/reset`
* `/v1/savepoint`
* `/v1/housekeeping`

Each endpoint conforms to the [JSON API specification](http://jsonapi.org/format/).

You can get all the endpoints by calling the `/v1/endpoints` endpoint with the right HTTP method and giving the expected arguments.

## Installation

```
npm i
node mmq.js
```

## Configuration

Update the values in `config.json` to your liking.

```javascript
{
    "user": "mmqadmin",    // User used to connect to the database
    "password": "mmqpwd", // Password for the user
    "host": "127.0.0.1",  // Hostname of the database
    "port": 3306,         // Port where the database is listening
    "listen": 3000        // Post where the API will listen
}
```

## Example output

TBW
