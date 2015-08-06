# Example based on the following article of Fábio Rehm:
# http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/

FROM ubuntu:14.04
MAINTAINER Jordi Febrer <jordi.febrer@gmail.com> 

# base
RUN apt-get update -y && \
    apt-get install -y  wget python git unzip curl
    
# replace 1000 with your user group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

# install firefox
RUN apt-get install -y firefox

# install chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN wget -N http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip -P /tmp/
RUN unzip /tmp/chromedriver_linux64.zip -d /tmp/
RUN chmod +x /tmp/chromedriver
RUN mv -f /tmp/chromedriver /usr/local/share/chromedriver
RUN ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
RUN ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
RUN cd /tmp/ && git clone https://github.com/jordifebrer/behave-jef.git

# install pip
RUN curl -s https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
RUN python /tmp/get-pip.py

# install behave and project requirements
RUN cd /tmp/behave-jef/ && pip install -r requirements.txt

USER developer
ENV HOME /home/developer
ENTRYPOINT ["behave","/tmp/behave-jef/features/"]
