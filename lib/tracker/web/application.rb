require 'sinatra'
require "tracker/web/version"
require 'tracker/application'

module Tracker
  module Web
    class Application < Sinatra::Application
      include Tracker::Application

      get('/'){'Hello, world.'}
      
      get('/stories/new'){erb :'stories/new'}
      
      get('/stories/:story_id') do
        result = LoadStory.perform(story_id: params[:story_id])
        erb :'stories/show', locals: result.story
      end

      post '/stories' do
        result = CreateStory.perform(title: params[:story][:title])
        redirect to('/stories/%d' % result.story_id)
      end

      post '/stories/:story_id/parent_story_stories' do
        context = {
          parent_story_id: params[:story_story][:parent_story_id].to_i,
          child_story_id: params[:story_id].to_i
        }

        result = CreateStoryStory.perform(context)
        redirect to('/stories/%d' % params[:story_id])
      end

      post '/stories/:story_id/child_story_stories' do
        context = {
          parent_story_id: params[:story_id].to_i,
          child_story_id: params[:story_story][:child_story_id].to_i
        }

        result = CreateStoryStory.perform(context)
        redirect to('/stories/%d' % params[:story_id])
      end

      post '/story_stories' do
        context = {
          parent_story_id: params[:story_story][:parent_story_id].to_i,
          child_story_id: params[:story_story][:child_story_id].to_i
        }

        result = CreateStoryStory.perform(context)
        redirect to "/stories/%d" % params[:story_story][:parent_story_id]
      end
    end
  end
end
