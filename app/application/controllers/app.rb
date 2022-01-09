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
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css'
                    
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    fake_data = YAML.load_file(File.join(File.dirname(__FILE__), '/fake_data.yml'))

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do # rubocop:disable Metrics/BlockLength
        # Get cookie viewer's previously viewed topics
        session[:watching] ||= []

        # headline_cluster = Views::HeadlineCluster.new(fake_data[:headline_cluster])
        result = Service::GetHeadlineCluster.new.call()
        if result.failure?
          flash[:error] = result.failure
          routing.redirect '/'
        end
        headline_cluster = Views::HeadlineCluster.new(result.value!)
        view 'home', locals: { headline_cluster: headline_cluster } 
      end

      routing.on 'topic' do
        
        routing.on String do |keyword|
          # GET /topic/{keyword}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)
            session[:watching] ||= []

            result = Service::GenerateTextCloud.new.call(keyword: keyword)
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end         
            stats = Views::TextCloud.new(result.value!)
            # request_feeds = result.value!
           
            response.expires 60, public: true
            view 'topic', locals: { stat: stats}

          end        
        end
      end

      routing.on 'tag' do
        
        routing.on String do |tag|
          # GET /tag/{tag}
          routing.get do
            # Request related videos info from database or from Youtube Api(if not found in database)
            session[:watching] ||= []

            result = Service::ProvideVideoList.new.call(tag: tag)
            # result = Views::Tag.new(fake_data[:video_list])

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            video_list = result.value!.tag
            result = Views::Tag.new(video_list)

            # Show viewer the tag
            response.expires 60, public: true
            view 'tag', locals: {tag: tag, result: result}  

          end        
        end
      end

    end
  end
end
