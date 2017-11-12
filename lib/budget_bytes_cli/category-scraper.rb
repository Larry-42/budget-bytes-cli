class BudgetBytesCli::CatgeoryScraper
    
    def open_page
        Nokogiri::HTML(open("https://www.budgetbytes.com/recipes/"))
    end
    
    def locate_categories
        open_page.css(".cat-item")
    end
    
    def create_categories
    end
end
