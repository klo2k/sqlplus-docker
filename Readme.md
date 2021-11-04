# Oracle SQL Plus docker image

My own image to test oracle db connectivity.


## Usage

Interactive:
```
docker run --rm -it --entrypoint=/bin/bash klo2k/sqlplus
sqlplus system/oracle@oracle.database.fqdn/service_name
```

Scripted:
```
# Via stdin
echo 'select user from dual;'|docker run --rm -i klo2k/sqlplus system/oracle@oracle.database.fqdn/service_name

# As "file"
docker run --rm -i klo2k/sqlplus system/oracle@oracle.database.fqdn/service_name <<EOT
select user from dual;
EOT
````
