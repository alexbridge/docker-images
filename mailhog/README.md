### Authentication

HTTP basic authentication using a password file.

See [example-auth](https://github.com/mailhog/MailHog/blob/master/docs/Auth.md) for an example

### Password file format

The password file format is:

- One user per line
- `username:password`
- Password is bcrypted

By default, a bcrypt difficulty of 4 is used to reduce page load times.

Locally `test / test` is used

### Generating a password

Run docker image with mailhog, log into containter, eg. `docker exec -it mailhog bash`

    MailHog bcrypt <password>

Add generated password to [.htpasswd](.htpasswd) file 

### Connect mailhog with other docker services

To connect to existing docker network, change `external-network` in docker-compose file to your existing network  
Use mailhog service

- host: mailhog
- port: 1025
- username / password: blank
