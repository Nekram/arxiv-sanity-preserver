FROM python:3.6.1

RUN mkdir /code
WORKDIR /code
# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd 

# prereqs for the arxiv sanity pip requirements
RUN apt-get -y upgrade
RUN apt-get install -y imagemagick poppler-utils sqlite3 build-essential unzip zip

ADD requirements.txt /code/
RUN pip install -r requirements.txt
ADD . /code/

COPY sshd_config /etc/ssh/
COPY startup.sh /usr/local/bin/
	
RUN chmod u+x /usr/local/bin/startup.sh
EXPOSE 5000 2222
ENTRYPOINT ["init.sh"]