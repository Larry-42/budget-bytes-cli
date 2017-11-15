class BudgetBytesCli::CLI
    def call
        puts "Welcome to Budget Bytes CLI!"
        scraper = BudgetBytesCli::CategoryScraper.new
        scraper.create_categories
        selection = ""
        while selection != 'Q'
            selection = get_input_categories
            if selection != 'Q'
                selected_category = BudgetBytesCli::Category.all[selection.to_i - 1]
                display_num_recipes(selected_category)
            end
        end
    end
    
    def display_num_recipes(category_chosen)
        unless category_chosen.recipes
            category_chosen.get_recipes
        end
        
        num_recipes = category_chosen.recipes.length
        
        puts "You picked #{category_chosen.name}."        
        puts "There are #{num_recipes} recipes in this category."
    end
    
    def display_items
        puts "Please select a recipe category from the list below:"
        menu_items = BudgetBytesCli::Category.all.map {|i| i.name}
        menu_items.each_with_index do |menu_item, idx|
            puts "#{idx + 1}.  #{menu_item}"
        end
        puts "Or enter 'Q' to exit"
    end
    
    def get_input_categories
        input = ""
        valid_input = false
        menu_length = BudgetBytesCli::Category.all.length
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
        input
    end
end
