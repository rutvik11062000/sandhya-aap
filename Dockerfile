ARG RUBY_VERSION=3.0.0

FROM ruby:$RUBY_VERSION-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libvips gnupg2 curl git libxml2-dev libxslt1-dev

# Ensure node.js 19 is available for apt-get
ARG NODE_MAJOR=19
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Install node and yarn
RUN apt-get update -qq && apt-get install -y nodejs && npm install -g yarn

# Mount $PWD to this workdir
WORKDIR /rails

# Ensure gems are installed on a persistent volume and available as bins
VOLUME /bundle
RUN bundle config set --global path '/bundle'
ENV PATH="/bundle/ruby/$RUBY_VERSION/bin:${PATH}"

# Install Rails
RUN gem install rails

# Ensure binding is always 0.0.0.0, even in development, to access server from outside container
ENV BINDING="0.0.0.0"
ENV RAILS_ENV=development

# copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# install gems
RUN bundle install

RUN gem install nokogiri --platform=ruby

# copy the project files into the image
COPY . .

# expose port 3000
EXPOSE 3000

# start the server
CMD ["rails", "server", "-b", "$BINDING", "-e", "development"]