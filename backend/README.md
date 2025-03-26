Instructions for how to connect to the AWS development server:

Tunnel to the RDS server by running the following in terminal:

ssh -i <Path to private key> -L 5432:crowd-search.craysg28gzdu.us-east-2.rds.amazonaws.com:5432 ec2-user@3.133.53.100

Replace the path to private key with the actual path.

Leave the tunnel running and initiate the backend in a separate terminal.
