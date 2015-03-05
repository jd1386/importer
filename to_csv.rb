require 'json'
require 'csv'


json_file = JSON.parse(File.open("data/es_recent_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# If all the books are successfully scraped, convert JSON to CSV

CSV.open("data/csv_test.csv", "w") do |csv|
  # Write header
  csv << ["cover_image/_alt", "book_page_url/_text", "book_page_url/_title", "book_page_url", "cover_image", "book_page_url/_source"]

 
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("cover_image/_alt", "book_page_url/_text", "book_page_url/_title", "book_page_url", "cover_image", "book_page_url/_source")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/csv_test.csv"