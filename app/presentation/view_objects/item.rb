module Views
    # View for a single contributor
    class Item
      def initialize(item)
        @item = item
      end
  
      def entity
        @item
      end
  
      def url
        @item[:article_url]
      end

      def title
        @item[:title]
      end

      def abstract
        @item[:abstract]
      end

      def img
        @item[:img]
      end

      def tag
        @item[:tag]
      end

    end
end