require 'spec_helper'
require 'database_cleaner'
require 'capybara/rspec'
require 'tracker/p_g'

ENV['TEST_DATABASE_URL'] ||= 'postgres://postgres@localhost:5432/new_tracker_test'
Capybara.app = Tracker::Web::Application.new

describe 'acceptance', type: :feature do  
  before(:all){Tracker::PG.database_url = ENV['TEST_DATABASE_URL']}
  after(:all){Tracker::PG.reset!}

  around do |example|
    DatabaseCleaner.strategy = :truncation
    example.run
    DatabaseCleaner.clean
  end

  it 'is ok' do
    visit '/stories/new'
    fill_in :story_title, with: 'Story title'
    click_on 'Create Story'
    page.should have_content 'Story title'
  end
end