FROM node:22-alpine  AS build

RUN mkdir /devops

WORKDIR /devops

COPY . /devops/

RUN  npm install && npm run build

FROM nginx:alpine AS run

RUN apk add nano

COPY --from=build /devops/dist/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

