module Views
    # View for a single contributor
    class Section
      def initialize(section_name, item_list)
        @section = {
            section_name: section_name,
            item_list: item_list
        }
      end
  
      def entity
        @section
      end

      def name
        @section[:section_name]
      end
  
      def items
        @section[:item_list].map do |item|
          Item.new(item)
        end
      end
    end
end