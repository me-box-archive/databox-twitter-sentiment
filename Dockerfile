FROM node:argon
#FROM iron/node

ADD package.json package.json
RUN npm install
ADD . .

LABEL databox.type="app"
LABEL databox.manifestURL="http://datashop.amar.io/databox-twitter-sentiment/manifest.json"

EXPOSE 8080

CMD ["npm","start"]
