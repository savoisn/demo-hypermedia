FROM node:0.12.7-wheezy

RUN mkdir /src

RUN npm install nodemon -g 
RUN npm install brunch -g 
RUN npm install bower -g 

WORKDIR /src
ADD package.json /src/package.json
RUN npm install 
ADD bower.json /src/bower.json
RUN bower install --allow-root

ADD nodemon.json /src/nodemon.json

EXPOSE 3333

CMD npm start
