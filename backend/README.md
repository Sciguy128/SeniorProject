These are instructions for how to connect to the postgres database before we migrate to a server:

Download PgAdmin4. I got it as part of my postgres instalation at the following link: https://www.postgresql.org/download/


In PgAdmin4, right click on servers and select register server...

Input a name for the database like SeniorProjectServer and then use the following connection info.

Host name/address: 172.20.82.116

Port: 5433 (One different from the default port)

Username: teammate

Password: crowdsearch


Once connected the project, crowd_search will be one of the connected database with all of our project data.
