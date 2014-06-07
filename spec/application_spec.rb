require 'spec_helper'
require 'rack/test'

module Tracker
  module Web
    describe Application do
      include Rack::Test::Methods

      def app
        Application.new
      end

      describe 'get /' do
        it 'is ok' do
          expect(get('/').body).to eq 'Hello, world.'
        end
      end

      describe 'get /stories/new' do
        it 'is ok' do
          expect(get('/stories/new').status).to eq 200
        end        
      end

      describe 'post /stories/99' do
        it 'perform LoadStory' do
          result = double(success?: true, story: { id: 1, title: 'My Story' })
          Application::LoadStory.stub(perform: result)
          response = get('stories/99')
          expect(Application::LoadStory).to have_received(:perform).with(story_id: '99')
          expect(response.status).to eq 200
        end
      end

      describe 'post /stories' do
        it 'performs CreateStory' do
          result = double(success?: true, story_id: 99)
          Application::CreateStory.stub(perform: result)
          response = post('stories', story: { title: 'My story' })
          expect(Application::CreateStory).to have_received(:perform)
          follow_redirect!
          expect(last_request.url).to eq 'http://example.org/stories/99'
        end
      end

      describe 'post /story_stories/:story_id/parent_story_stories' do
        it 'performs CreateStoryStory' do
          result = double(success?: true, story_story_id: 109)
          Application::CreateStoryStory.stub(perform: result)
          response = post('stories/65/parent_story_stories', story_story: { parent_story_id: 66 })
          expect(Application::CreateStoryStory).to have_received(:perform).with(child_story_id: 65, parent_story_id: 66)
          follow_redirect!
          expect(last_request.url).to eq 'http://example.org/stories/65'
        end
      end

      describe 'post /story_stories/:story_id/child_stories' do
        it 'performs CreateStoryStory' do
          result = double(success?: true, story_story_id: 109)
          Application::CreateStoryStory.stub(perform: result)
          response = post('stories/200/child_story_stories', story_story: { child_story_id: 201 })
          expect(Application::CreateStoryStory).to have_received(:perform).with(parent_story_id: 200, child_story_id: 201)
          follow_redirect!
          expect(last_request.url).to eq 'http://example.org/stories/200'
        end
      end

      describe 'post /story_stories' do
        it 'performs CreateStoryStory' do
          result = double(success?: true, story_story_id: 101)
          Application::CreateStoryStory.stub(perform: result)
          response = post('story_stories', story_story: { child_story_id: 104, parent_story_id: 103 })
          expect(Application::CreateStoryStory).to have_received(:perform).with(child_story_id: 104, parent_story_id: 103)
          follow_redirect!
          expect(last_request.url).to eq 'http://example.org/stories/103'
        end
      end
    end
  end
end