class BudgetBytesCli::CLI
    
    def call
        puts "Welcome to Budget Bytes CLI!"
        BudgetBytesCli::CategoryScraper.create_categories
        category_selector = BudgetBytesCli::ArrayPrompter.new("Selecting recipe category.")
        category_selector.array_to_select = BudgetBytesCli::Category.all.map {|i| i.name}
        
        recipe_selector = BudgetBytesCli::ArrayPrompter.new("Selecting recipe")
        
        cat_combination_selector = BudgetBytesCli::ArrayPrompter.new("Selecting category to combine.")
        
        current_selector = category_selector
        selection = category_selector.get_input
        
        #define variables outside of while loop scope
        selected_category = nil
        filtered_categories = []
        recipe_array = []
        
        while selection != 'Q'
            if current_selector == category_selector
                selected_category = BudgetBytesCli::Category.all[selection.to_i - 1]
                whether_to_combine = yes_no_input("Combine with another category?\nIn other words, display only recipes in both the current category and another you select?\n")
                if whether_to_combine == 'Y'
                    current_selector = cat_combination_selector
                    filtered_categories = BudgetBytesCli::Category.all.select do |c|
                        c != selected_category
                    end
                    cat_combination_selector.array_to_select = filtered_categories.map {|i| i.name}
                else
                    current_selector = recipe_selector
                    recipe_array = selected_category.recipes
                    recipe_selector.array_to_select = selected_category.recipes.map {|i| i.name}
                end
            elsif current_selector == cat_combination_selector
                combination_category = filtered_categories[selection.to_i - 1]
                recipe_array = selected_category.combine_recipes(combination_category)
                if recipe_array.empty?
                    valid_input_empty_array = false
                    while !valid_input_empty_array
                        puts "No recipes are in the two categories to combine."
                        puts "Enter 'B' to select a different category to combine,"
                        puts "'C' to start fresh with a different recipe category,"
                        puts "or 'I' to ignore the recipe combination and use the category you chose."
                        empty_array_input = gets.strip.upcase
                        if empty_array_input == 'B'
                            current_selector = cat_combination_selector
                            #not necessary, but makes explicit that we're running this again
                            valid_input_empty_array = true
                        elsif empty_array_input == 'C'
                            valid_input_empty_array = true
                            current_selector = category_selector
                        elsif empty_array_input == 'I'
                            valid_input_empty_array = true
                            current_selector = recipe_selector
                            recipe_array = selected_category.recipes
                            recipe_selector.array_to_select = selected_category.recipes.map {|i| i.name}
                        end
                    end
                else
                    current_selector = recipe_selector
                    recipe_selector.array_to_select = recipe_array.map {|i| i.name}
                end
            else
                selected_recipe = recipe_array[selection.to_i - 1]
                self.display_recipe(selected_recipe)
                current_selector = category_selector
            end
            selection = current_selector.get_input
        end
    end
    
    def display_recipe(recipe_chosen)
        if recipe_chosen.ingredients == "" || recipe_chosen.instructions == ""
            puts "Error!  Could not scrape recipe from page selected!"
        else
            puts recipe_chosen.name
            puts "\nIngredients\n"
            puts recipe_chosen.ingredients
            puts ""
            page_width = IO.console.winsize[1]
            puts reformat_wrapped(recipe_chosen.instructions, page_width || 80)
            puts ""
            if yes_no_input("Do you want to open this recipe in your browser?") == 'Y'
                Launchy.open(recipe_chosen.url)
            end
        end
    end
    
    def yes_no_input (prompt)
        puts prompt + " Please answer 'y' or 'n'"
        input = gets.strip.upcase
        while !['Y', 'N'].include?(input)
            puts "Invalid input."
            puts prompt + " Please answer 'y' or 'n'" 
            input = gets.strip.upcase
        end
        input
    end
    
    #from https://www.safaribooksonline.com/library/view/ruby-cookbook/0596523696/ch01s15.html
	def reformat_wrapped(s, width= 78)
	  lines = []
	  line = ""
	  s.split(/\s+/).each do |word|
	    if line.size + word.size >= width
	      lines << line
	      line = word
	    elsif line.empty?
	     line = word
	    else
	     line << " " << word
	   end
	   end
	   lines << line if line
	  return lines.join "\n"
	end
end
