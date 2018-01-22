FROM node:9.4

COPY . ./

RUN npm install

ENTRYPOINT ["./bin/hubot"]
CMD ["-a", "shell"]
