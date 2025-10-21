FROM ubuntu:latest

RUN apt update && apt install -y curl

COPY . /app
WORKDIR /app

CMD ["bash"]
