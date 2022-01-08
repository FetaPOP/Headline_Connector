module Views
    # View for a single contributor
    class Video
      def initialize(video)
        @video = video
      end
  
      def entity
        @video
      end

      def key
        @video
      end
  
    end
  end