##################################################################
# Dockerfile to create a PIMATIC container
# Tested and designed for Synology Diskstation but should run in all docker environments.
##################################################################

# We are using debian as the base image
FROM debian

# Author
MAINTAINER petschni

####### Base installation of NodeJS #######
# Install NodeJS v7.x
RUN apt-get update
RUN apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

####### PIMATIC installaton #######
RUN apt-get install -y build-essential git
RUN mkdir /home/pimatic-app
RUN /usr/bin/env node --version
RUN cd /home && npm install pimatic --prefix pimatic-app --production


####### Instal globally #######
RUN cd /home/pimatic-app/node_modules/pimatic && npm link

####### Copy the default config to our installation #######
RUN cp /home/pimatic-app/node_modules/pimatic/config_default.json /home/pimatic-app/config.json

####### Config the autostart #######
RUN wget https://raw.githubusercontent.com/pimatic/pimatic/v0.9.x/install/pimatic-init-d && cp pimatic-init-d /etc/init.d/pimatic
RUN chmod +x /etc/init.d/pimatic
RUN chown root:root /etc/init.d/pimatic
RUN update-rc.d pimatic defaults

####### Link the persistent config.json file and start the pimatic service #######
CMD rm /home/pimatic-app/config.json && ln -s /home/pimatic-app/configMount/config-json-pimatic.json /home/pimatic-app/config.json && service pimatic start && bash

# Expose port 1122
EXPOSE 1122
