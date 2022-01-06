module Views
    # View for a single contributor
    class HeadlineCluster
      def initialize(headline_cluster)
        @headline_cluster = headline_cluster
      end
  
      def entity
        @headline_cluster
      end
  
      def section
        @headline_cluster.each |section_name, item_list|
          Section.new(section_name, item_list)
        end
      end

    end
  end