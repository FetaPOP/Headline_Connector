# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'yaml'
require_relative 'helpers'

module HeadlineConnector
  # Web App
  class App < Roda
    include RouteHelpers

    plugin :halt
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'
                    
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength

        result = Service::GetHeadlineCluster.new.call()
        if result.failure?
          puts result.failure
          routing.redirect '/'
        end
        headline_cluster = Views::HeadlineCluster.new(result.value!)

        response.expires 60, public: true
        view 'home', locals: { headline_cluster: headline_cluster } 
      end

      routing.on 'topic' do
        routing.on String do |keyword|
          # GET /topic/{keyword}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)

            result = Service::GenerateTextCloud.new.call(keyword: keyword)
            if result.failure?
              puts result.failure
              routing.redirect '/'
            end        
            
            text_cloud = Views::TextCloud.new(result.value!)
           
            response.expires 60, public: true
            view 'topic', locals: { text_cloud: text_cloud, keyword: keyword}
          end        
        end
      end

      routing.on 'tag' do
        routing.on String do |tag|
          # GET /tag/{tag}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)

            result = Service::ProvideVideoList.new.call(tag: tag)

            if result.failure?
              puts result.failure
              routing.redirect '/'
            end

            result = Views::Tag.new(result.value!)

            # Show viewer the tag
            response.expires 60, public: true
            view 'tag', locals: {tag: tag, result: result}  

          end        
        end
      end

    end
  end
end
