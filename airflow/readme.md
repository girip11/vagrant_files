# Setting up Airflow

After running `vagrant up`, we need to ssh to the VM using `vagrant ssh` and run the following commands

```Bash
airflow scheduler &
airflow webserver -p 8080 &
```
