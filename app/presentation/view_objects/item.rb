module Views
    # View for a single contributor
    class Item
      def initialize(headline_cluster)
        @headline_cluster = headline_cluster
      end
  
      def entity
        @headline_cluster
      end
  
      def title
        @topic.key
      end

      def related_videos_ids
        @topic.related_videos_ids
      end

    end
  end