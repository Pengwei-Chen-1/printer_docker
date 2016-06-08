# Version 0.0.1
FROM isntall/centos6-base
MAINTAINER pengwei_chen "pengwei_chen@qq.com"
# install jdk
RUN yum -y install java-1.7.0-openjdk*
# install tomcat
RUN wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz
RUN tar xvf apache-tomcat-7.0.69.tar.gz
RUN mv apache-tomcat-7.0.69 tomcat
RUN rm -rf apache-tomcat-7.0.69.tar.gz
# install git
RUN yum install -y git
RUN mkdir workspace
RUN git clone https://github.com/guduchina/printer.git workspace/
#install maven
RUN wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN tar xvf apache-maven-3.3.9-bin.tar.gz
RUN mv apache-maven-3.3.9 maven
RUN rm -rf apache-maven-3.3.9-bin.tar.gz
ADD settings.xml /maven/conf/
ADD printer.xml /tomcat/conf/Catalina/localhost/
ENV M2_PATH /maven
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk.x86_64
ENV PATH $PATH:$M2_PATH/bin:$JAVA_HOME/bin
RUN source /etc/profile
# ---mvn package
RUN cd workspace/ && mvn package
ADD db-config.properties /workspace/target/printer/WEB-INF/classes/
EXPOSE 8080
ENTRYPOINT ["tomcat/bin/catalina.sh", "run"]
