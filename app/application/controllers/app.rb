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

        headline_cluster = Views::HeadlineCluster.new(fake_data[:headline_cluster])
        #headline_cluster = Service::GetHeadlineCluster.new.call()

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

            text_cloud = result.value!

            # Show viewer the topic
            # Need to change to topic view object
            response.expires 60, public: true
            view 'topic', locals: { keyword: keyword, text_cloud: text_cloud }  

          end        
        end
      end
    end
  end
end
