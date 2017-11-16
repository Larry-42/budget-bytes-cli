#ArrayPrompter uses an ArraySelector for blocks of 20 (if needed) and
#an ArraySelector for the block of 20 chosen, returns the overall selection
class BudgetBytesCli::ArrayPrompter
    attr_accessor :prompt_text, :array_to_select
    
    def initialize
        @block_selector = BudgetBytesCli::ArraySelector.new
        @item_selector = BudgetBytesCli::ArraySelector.new
    end
    
    def get_input
        num_blocks = (self.array_to_select.length.to_f / 20.to_f).ceil
        
        #makes sure variable is outside if statement scope
        input_selected = 1
        
        #only go through block iteration if there are > 1 block!
        if num_blocks > 1
            @block_selector.prompt_text = self.prompt_text + "\nPlease select a range below"
            
            #create array for block selector
            @block_selector.array_to_select = []
            (1..num_blocks).each do |n|
                @block_selector.array_to_select << "#{(n - 1) * 20 + 1}-#{[(n * 20), self.array_to_select.length].min}"
            end
            
            input_selected = @block_selector.get_input
        end
        
        if input_selected != 'Q'
            #Gets input using item_selector ArraySelector
            selected_value = input_selected.to_i
            @item_selector.prompt_text = self.prompt_text + "\nPlease select an item below."
            block_min = (selected_value - 1) * 20
            block_max = [(selected_value * 20) - 1, self.array_to_select.length].min
            @item_selector.array_to_select = self.array_to_select[block_min..block_max]
            second_selection = @item_selector.get_input
            if second_selection != 'Q'
                input_selected = (second_selection.to_i + (selected_value - 1) * 20).to_s
            end
        end
        input_selected
    end
end

#ArraySelector selects from an array (helper class for ArrayPrompter)
class BudgetBytesCli::ArraySelector
    attr_accessor :prompt_text, :array_to_select
    def last_item
        self.array_to_select.length
    end
    
    def prompt(text_prompt = nil)
        if text_prompt
            self.prompt_text = text_prompt
        end
        
        puts self.prompt_text
        self.array_to_select.each_with_index do |menu_item, idx|
            puts "#{idx + 1}.  #{menu_item}"
        end
        puts "Or enter 'Q' to quit"
    end
    
    def get_input
        input = ""
        valid_input = false
        while !valid_input
            self.prompt
            input = gets.strip.upcase
            if input == 'Q'
                valid_input = true        
            elsif input.to_i.to_s == input && input.to_i >= 1 && input.to_i <= self.last_item
                valid_input = true
            else
                puts "Invalid input, please try again."
            end
        end
        input
    end
end
