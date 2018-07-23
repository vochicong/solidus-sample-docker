set -ex

rails db:create
rails g solidus:auth:install
rails railties:install:migrations
rails db:migrate
rails db:seed
rails spree_sample:load
rails assets:precompile
