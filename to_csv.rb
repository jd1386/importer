require 'json'
require 'csv'
require 'awesome_print'

### 
# This program converts json file to csv format without data loss.
###

def fix_encoding(string)
  string.encode("cp1252").force_encoding("UTF-8").scrub! if string != nil
end

file = File.read("data/to_csv_source.json", encoding: 'utf-8')

@parsed_response = JSON.parse(file).force_encoding('UTF-8')
@json_file_size = @parsed_response["pages"].size

ap @json_file_size


# Save @parsed_response to CSV
CSV.open("data/to_csv_results.csv", "w", encoding: 'UTF-8') do |csv|
  # Write the results header to csv
  csv << ["pageUrl", "isbn", "title", "categories/_text", "age_group"]

  (0...@json_file_size).each do |i|    

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
      pageUrl = fix_encoding(pageUrl)

      isbn = @parsed_response["pages"][i]["results"][0]["isbn"]
      isbn = fix_encoding(isbn)

      title = @parsed_response["pages"][i]["results"][0]["title"]
      title = fix_encoding(title)

      if @parsed_response["pages"][i]["results"][0]["categories/_text"].nil?
        categories = "N/A"
      else
        categories = @parsed_response["pages"][i]["results"][0]["categories/_text"].join(", ")
        categories = fix_encoding(categories)
      end
      
      ap categories
     

      if @parsed_response["pages"][i]["results"][0]["age_group"].is_a? Array
        age_group = @parsed_response["pages"][i]["results"][0]["age_group"][0]
      else
        age_group = @parsed_response["pages"][i]["results"][0]["age_group"]
      end
      age_group = fix_encoding(age_group)


      csv << [pageUrl, isbn, title, categories, age_group]
    end
  end # end each loop

end # end CSV
