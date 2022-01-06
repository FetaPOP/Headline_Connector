module Views
    # View for a single contributor
    class HeadlineCluster
      def initialize(headline_cluster)
        @headline_cluster = headline_cluster
      end
  
      def entity
        @headline_cluster
      end
  
      def sections
        @headline_cluster.map do |section_name, item_list|
          puts "section_name: #{section_name}, item_list: #{item_list}"
          Section.new(section_name, item_list)
        end
      end
    end
end