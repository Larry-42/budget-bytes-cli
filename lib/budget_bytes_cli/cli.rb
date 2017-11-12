class BudgetBytesCli::CLI
    def call
        puts "Welcome to Budget Bytes CLI!"
        scraper = BudgetBytesCli::CatgeoryScraper.new
        scraper.create_categories
        display_items
    end
    
    def display_items
        puts "Please select a recipe category from the list below:"
        menu_items = BudgetBytesCli::Catgeory.all.map {|i| i.name}
        menu_items.each_with_index do |menu_item, idx|
            puts "#{idx + 1}.  #{menu_item}"
        end
        puts "Or enter 'Q' to exit"
    end
end
