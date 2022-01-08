module Views
    # View for a single contributor
    class TimeSection
      def initialize(duration, video_list)
        @time_section = {
          duration: duration,
          video_list: video_list
        }
      end
  
      def entity
        @time_section
      end

      def duration
        @time_section[:duration]
      end

      def video_list
        @time_section[:video_list].map do |video|
          Video.new(video)
        end
      end
  
    end
  end