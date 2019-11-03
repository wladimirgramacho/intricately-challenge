# Intricately API Challenge


### Setup

To setup the project run:

```
docker-compose build
docker-compose run api rails db:setup
```

To start the server run:

```
docker-compose up
```


### Test

For testing run:

```
docker-compose run api rspec
```


## API

### Endpoint 1 (POST /dns_record):

This endpoint creates a DNS record and associates it with the hostnames.

cURL example:
```
curl --request POST \
--url 'http://localhost:3000/dns_record' \
--header 'content-type: application/json' \
--data '{
  "dns_record": {
    "ip": "1.1.1.1",
    "hostnames_attributes": [
      {
        "hostname": "lorem.com"
      }
    ]
  }
}'
```

### Endpoint 2 (GET /dns_records):

This endpoint retrieves DNS records and informations about them.

cURL example:
```
curl --request GET \
--url 'http://localhost:3000/dns_records?page=1&included_hostnames[]=ipsum.com&included_hostnames[]=dolor.com&excluded_hostnames[]=sit.com' \
--header 'content-type: application/json'
```
