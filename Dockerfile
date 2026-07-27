FROM node:22-alpine  AS build

RUN mkdir /devops

WORKDIR /devops

COPY . ./

RUN cd ./frontend1 && npm install && npm run build
RUN cd ./frontend2 && npm install && npm run build
RUN cd ./frontend3 && npm install && npm run build

FROM nginx:alpine AS run

RUN apk add nano

COPY index.html /usr/share/nginx/html/
COPY app.css /usr/share/nginx/html/

COPY --from=build /devops/frontend1/dist/assets/ /usr/share/nginx/html/assets/
COPY --from=build /devops/frontend2/dist/assets/ /usr/share/nginx/html/assets/
COPY --from=build /devops/frontend3/dist/assets/ /usr/share/nginx/html/assets/

COPY --from=build /devops/frontend1/dist /usr/share/nginx/html/frontend1
COPY --from=build /devops/frontend2/dist /usr/share/nginx/html/frontend2
COPY --from=build /devops/frontend3/dist /usr/share/nginx/html/frontend3

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

