require 'json'
require 'csv'

### 
# This program converts json file to csv format without data loss.
###


file = File.read("data/to_csv_source.json", encoding: 'utf-8')

@parsed_response = JSON.parse(file)
@pages = @parsed_response["pages"].size

puts "Loaded #{@pages} pages"


# Save @parsed_response to CSV
CSV.open("data/to_csv_results.csv", "w", encoding: 'UTF-8') do |csv|
  # Write the results header to csv
  csv << ["pub_date", "link", "format", "link/_text", "link/_title", "pageUrl"]

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
      # Each page has n items to scrape
      (0..9).each do |n|
        # Write the results body to csv
        @parsed_response["pages"][i]["results"][n]
        pub_date = @parsed_response["pages"][i]["results"][n]["pub_date"]
        link = @parsed_response["pages"][i]["results"][n]["link"]
        format = @parsed_response["pages"][i]["results"][n]["format"]
        link_text = @parsed_response["pages"][i]["results"][n]["link/_text"]
        link_title = @parsed_response["pages"][i]["results"][n]["link/_title"]
        pageUrl = @parsed_response["pages"][i]["pageUrl"]


        csv << [pub_date, link, format, link_text, link_title, pageUrl]
      end
    end
  end # end each loop

end # end CSV

puts "Parsed and processed #{@pages} pages"