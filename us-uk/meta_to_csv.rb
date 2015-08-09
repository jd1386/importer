require 'json'
require 'csv'

### 
# This program converts json file to csv format without data loss.
###


file = File.read('/Users/jungdolee/projects/importer/data/to_csv_source.json', encoding: 'utf-8')

@parsed_response = JSON.parse(file)
@pages = @parsed_response["pages"].size

puts "Loaded #{@pages} pages"


# Save @parsed_response to CSV
CSV.open("/Users/jungdolee/projects/importer/data/to_csv_results.csv", "w", encoding: 'UTF-8') do |csv|
  # Write the results header to csv
  csv << [ "pageUrl", "publisher", "title", "authors", "cover_image", "description", "meta_all", "categories_1", "categories_2" ]

  (0...@pages).each do |i|    

    if @parsed_response["pages"][i]["results"].nil?
        csv << [
                fix_encoding(@parsed_response["pages"][i]["pageUrl"]),
                "Nil"
        ]

     # If no results found with the given isbn prefix
    elsif @parsed_response["pages"][i]["results"].empty?
        csv << [
                @parsed_response["pages"][i]["pageUrl"],
                "Empty"
        ]

    else
      
        # Write the results body to csv
        pageUrl = @parsed_response["pages"][i]["pageUrl"]
        publisher = @parsed_response["pages"][i]["results"][0]["publisher"]
        title = @parsed_response["pages"][i]["results"][0]["title"]
        authors = @parsed_response["pages"][i]["results"][0]["authors"]
        cover_image = @parsed_response["pages"][i]["results"][0]["cover_image"]
        description = @parsed_response["pages"][i]["results"][0]["description"]
        meta_all = @parsed_response["pages"][i]["results"][0]["meta_all"]
        categories_1 = @parsed_response["pages"][i]["results"][0]["categories_1"]
        categories_2 = @parsed_response["pages"][i]["results"][0]["categories_2"]
        


        csv << [ pageUrl, publisher, title, authors, cover_image, description, meta_all, categories_1, categories_2 ]
      
    end
  end # end each loop

end # end CSV

puts "Parsed and processed #{@pages} pages"