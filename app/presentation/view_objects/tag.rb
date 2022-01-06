module Views
    # View for a single contributor
    class Tag
      def initialize(tag)
        @tag = tag
      end
  
      def entity
        @tag
      end

      def time_section
        @tag.map do |duration, video_list|
            TimeSection.new(duration, video_list)
        end
      end
  
    end
  end