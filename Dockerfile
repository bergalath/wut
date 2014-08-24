# Latest Ubuntu LTS docker friendly image from Phusion
FROM phusion/baseimage:latest

MAINTAINER Bertrand Gauriat "bga@bga.la"

# Update apt-cache ; upgrade needed ?
RUN apt-get update
RUN apt-get install -y make gcc libxslt-dev libxml2-dev wget git-core
 
# Add repo & key for Ruby 2.1 (and dependencies ?)
RUN wget -q -O - http://apt.hellobits.com/hellobits.key | sudo apt-key add -
RUN echo 'deb http://apt.hellobits.com/ trusty main' | sudo tee /etc/apt/sources.list.d/hellobits.list

# Install Ruby & Bundler
RUN apt-get update
RUN apt-get install -y ruby-2.1
RUN gem install bundler

# Pull project from github
RUN git clone https://github.com/bergalath/wut.git /home/wut # may not the best destination ?!

WORKDIR /home/wut

# Setup project environment
RUN bundle install --path=vendor --binstubs

EXPOSE 9292

CMD ["./bin/rackup"]
