module Views
    # View for a single contributor
    class Section
      def initialize(section_name, item_list)
        @section_name = section_name,
        @item_list = item_list
      end
  
      def section
        @section_name
      end
  
      def item_list
        @item_list.each |section_name, item_list|
          Item.new(section_name, item_list)
      end
      end


    end
  end