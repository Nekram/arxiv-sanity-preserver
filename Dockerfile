#FROM mongo:4.4.0-rc13-bionic
FROM mongo:4.2.8-bionic
ADD . /code/
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
RUN apt-get install -y imagemagick poppler-utils sqlite3 build-essential libopenblas-dev ghostscript sudo python3-pip
RUN mkdir -p /data/db

# adding the file as.db 
ADD schema.sql /code/
RUN sqlite3 /code/as.db < /code/schema.sql

ADD requirements.txt /code/
RUN pip3 install -r requirements.txt
RUN chmod -R 777 .

# Fix the image magick security policy. Otherwise it will fail on pdfs. 
RUN sudo sed -i_bak 's/rights="none" pattern="PDF"/rights="read | write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml
RUN cat /etc/ImageMagick-6/policy.xml 
COPY sshd_config /etc/ssh/
COPY init.sh /usr/local/bin/
	
RUN chmod u+x /usr/local/bin/init.sh
EXPOSE 5000 2222
ENTRYPOINT ["init.sh"]