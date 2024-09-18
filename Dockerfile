FROM ruby:3.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
WORKDIR /myapp
ADD Gemfile Gemfile.lock /myapp/
RUN bundle install
ADD . /myapp
