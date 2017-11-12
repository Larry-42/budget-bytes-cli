class BudgetBytesCli::CatgeoryScraper
    
    def open_page
        Nokogiri::HTML(open("https://www.budgetbytes.com/recipes/"))
    end
    
    def locate_categories
        open_page.css(".cat-item")
    end
    
    def create_categories
        locate_categories.each do |item|
            url = item.css("a").attribute("href").value
            title = item.css("a").children[0].text
        end
    end
end
