module Views
    # View for a single contributor
    class TextCloud
      def initialize(text_cloud)
        @text_cloud = text_cloud
      end
  
      def entity
        @text_cloud.stats.map do |word|
          word["appearTimes"] = word["appearTimes"] * 3
          word
        end
      end
  
      def stats
        entity
      end
  
    end
  end