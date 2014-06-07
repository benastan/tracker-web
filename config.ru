require 'tracker/web/application'
require 'tracker/p_g'

ENV['DATABASE_URL'] ||= 'postgres://postgres@localhost:5432/new_tracker_development'
Tracker::PG.database_url = ENV['DATABASE_URL']
run Tracker::Web::Application