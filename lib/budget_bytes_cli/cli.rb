class BudgetBytesCli::CLI
    def call
        puts "Welcome to Budget Bytes CLI!"
        scraper = BudgetBytesCli::CatgeoryScraper.new
        scraper.create_categories
        selection = get_input
    end
    
    def display_items
        puts "Please select a recipe category from the list below:"
        menu_items = BudgetBytesCli::Catgeory.all.map {|i| i.name}
        menu_items.each_with_index do |menu_item, idx|
            puts "#{idx + 1}.  #{menu_item}"
        end
        puts "Or enter 'Q' to exit"
    end
    
    def get_input
        input = ""
        valid_input = false
        menu_length = BudgetBytesCli::Catgeory.all.length
        while !valid_input
            display_items
            input = gets.strip.upcase
            if input == 'Q'
                valid_input = true
            elsif input.to_i.to_s == input && input.to_i >= 0 && input.to_i <= menu_length
                valid_input = true
            else
                puts "Invalid input, please try again."
            end
        end
    end
end
