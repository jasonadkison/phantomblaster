FROM ruby:2.3.1
LABEL maintainer="jadkison@gmail.com"
RUN apt-get update
ENV BUILD_DIR /build
RUN mkdir -p $BUILD_DIR
RUN gem install bundler
WORKDIR $BUILD_DIR
