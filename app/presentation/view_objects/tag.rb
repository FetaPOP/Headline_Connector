module Views
    # View for a single contributor
    class Tag
      def initialize(tag)
        @tag = tag
      end
  
      def entity
        @tag
      end

      def time_sections
        timer_section_array = Array.new
        timer_section_array.push(TimeSection.new("this_week", entity.this_week))
        timer_section_array.push(TimeSection.new("this_month", entity.this_month))
        timer_section_array.push(TimeSection.new("this_year", entity.this_year))
        timer_section_array.push(TimeSection.new("before_this_year", entity.before_this_year))
      end
  
    end
  end