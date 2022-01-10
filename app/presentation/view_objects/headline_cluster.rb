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
      @headline_cluster.sections
    end
  end
end