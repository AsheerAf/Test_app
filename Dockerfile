ARG RELEASE
ARG LAUNCHPAD_BUILD_ARCH
LABEL org.opencontainers.image.ref.name=ubuntu
LABEL org.opencontainers.image.version=20.04
ADD file:7486147a645d8835a5181c79f00a3606c6b714c83bcbfcd8862221eb14690f9e in /
CMD ["/bin/bash"]
RUN /bin/sh -c apt update && apt-get -s dist-upgrade | grep "^Inst" | grep -i securi | awk -F " " {'print $2'} | xargs apt-get install # buildkit
RUN /bin/sh -c apt install --no-install-recommends -y openjdk-11-jre-headless # buildkit
RUN /bin/sh -c DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y mysql-server-8.0 && service mysql start && chmod 755 /var/run/mysqld && mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'" # buildkit
RUN /bin/sh -c apt install --no-install-recommends -y sudo vim-tiny # buildkit
RUN /bin/sh -c apt clean && rm -rf /var/lib/apt/lists/* # buildkit
RUN /bin/sh -c groupadd tomcat && useradd tomcat -g tomcat && echo "tomcat:tomcat" | chpasswd && usermod -aG 0 tomcat && usermod -aG sudo tomcat && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && chmod 664 /etc/passwd # buildkit
CMD ["bash"]
ENV ASPECTJ_VERSION=aspectjweaver-1.9.22
ENV LIB_HOME=/opt/joget/lib
ENV WFLOW_HOME=/opt/joget/wflow
ENV MYSQL_HOST=localhost
ENV MYSQL_PORT=3306
ENV MYSQL_DATABASE=jwdb
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=root
ENV JAVA_OPTS=-XX:MinRAMPercentage=50 -XX:MaxRAMPercentage=70 -Dwflow.home=/opt/joget/wflow -javaagent:/opt/joget/lib/aspectjweaver-1.9.22.jar -javaagent:/opt/joget/lib/glowroot/glowroot.jar
COPY /opt/joget /opt/joget # buildkit
USER tomcat
VOLUME [/opt/joget/wflow]
EXPOSE map[8080/tcp:{}]
EXPOSE map[9090/tcp:{}]
EXPOSE map[4000/tcp:{}]
ENTRYPOINT ["/opt/joget/run.sh"]
CMD [""]



