FROM openjdk:8
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get purge mysql*
RUN apt-get autoremove
RUN apt-get autoclean
RUN rm -rf /etc/mysql/ /var/lib/mysql
RUN wget http://dev.mysql.com/get/mysql-apt-config_0.8.1-1_all.deb
RUN dpkg -i mysql-apt-config_0.6.0-1_all.deb || true
RUN apt-get update
RUN apt-get install -y mysql-server
#RUN rm -rf /var/lib/mysql/*
ADD build/my.cnf /etc/mysql/my.cnf
ADD build/dbconfig.xml /var/atlassian/application-data/jira
RUN mkdir /etc/mysql/run
ADD runit/mysql.sh /etc/mysql/run
RUN chmod +x /etc/mysql/run
ADD build/Setup /root/setup
ADD my_init.d/99_mysql_setup.sh /etc/my_init.d/99_mysql_setup.sh
RUN chmod +x /etc/my_init.d/99_mysql_setup.sh
#ADD my_init.d/Jiradb.sql /etc/Jiradb.sql
#RUN chmod +x /etc/Jiradb.sql
#RUN /bin/bash -c "/usr/bin/mysqld_safe &" && \
#sleep 5 && \
#/opt/atlassian/jira/bin/start-jira.sh && \
#service mysql start && \
#mysql -uroot -proot -e "CREATE DATABASE Jiradb" && \
#mysql -uroot -proot Jiradb < /etc/Jiradb.sql
#CMD docker exec -it mysql -uroot -proot Jiradb < /etc/Jiradb.sql
EXPOSE 3306
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/usr/bin/mysqld_safe"]
#CMD ["/opt/atlassian/jira/bin/start-jira.sh", "run"]
