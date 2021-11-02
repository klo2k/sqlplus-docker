# Oracle SQL Plus docker image

My own image to test oracle db connectivity.


## Usage

Interactive:
```
docker run --rm -it klo2k/sqlplus:development
sqlplus system/oracle@oracle.database.fqdn/service_name
```

Scripted:
```
docker run --rm klo2k/sqlplus:development bash -c 'echo "select user from dual;"|sqlplus -L -S system/oracle@oracle.database.fqdn/service_name'
````
