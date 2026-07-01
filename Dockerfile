# set base image (host OS)
FROM python:3.8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get -y update
RUN apt-get install -y curl nano wget nginx git

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Node.js 14.x (required for react-scripts 4.0.1 compatibility)
# RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
# RUN apt-get install -y nodejs
# Install Node.js 14.x via official binary tarball (required for react-scripts 4.0.1 compatibility)
RUN curl -fsSL https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.xz -o /tmp/node.tar.xz \
  && tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1 \
  && rm /tmp/node.tar.xz
# Mongo
RUN ln -s /bin/echo /bin/systemctl
# RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
# RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# RUN apt-get -y update
# RUN apt-get install -y mongodb-org
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN wget http://archive.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1n-0+deb10u6_amd64.deb \
    && dpkg -i libssl1.1_1.1.1n-0+deb10u6_amd64.deb \
    && rm libssl1.1_1.1.1n-0+deb10u6_amd64.deb

RUN apt-get -y update
RUN apt-get install -y mongodb-org

# # Install Yarn
# RUN apt-get install -y yarn
# Install Yarn via npm (Node 14 already installed above)
RUN npm install -g yarn

# Install PIP
# RUN easy_install pip


ENV ENV_TYPE staging
ENV MONGO_HOST mongo
ENV MONGO_PORT 27017
##########

ENV PYTHONPATH=$PYTHONPATH:/src/

# copy the dependencies file to the working directory
COPY src/requirements.txt .

# install dependencies
RUN pip install -r requirements.txt
