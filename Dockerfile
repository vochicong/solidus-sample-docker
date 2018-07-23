FROM ruby:2.4-alpine

ENV APP_HOME=/app\
    LANG=C.UTF-8 \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

RUN rm -Rf ${APP_HOME}
WORKDIR ${APP_HOME}

RUN apk add --update \
    build-base \
    imagemagick \
    file \
    libxml2-dev \
    libxslt-dev \
    mariadb-dev \
    nodejs \
    tzdata \
    yarn
RUN gem install rails
RUN rails new . -f -d mysql

COPY Gemfile-solidus ./
RUN cat Gemfile-solidus >> Gemfile
RUN bundle install && rake assets:clean

RUN rails g spree:install --migrate=false --sample=false --seed=false
RUN rails g solidus_social:install
RUN rails assets:precompile
RUN RAILS_ENV=production rails assets:precompile

COPY setup.sh ./

EXPOSE 3000
CMD exec rails s -b 0.0.0.0
