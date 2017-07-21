RUN mysql -uroot -proot -e "CREATE DATABASE Jiradb"
RUN mysql -uroot -proot Jiradb < /etc/Jiradb.sql
