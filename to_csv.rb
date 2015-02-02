require 'json'
require 'csv'


json_file = JSON.parse(File.open("data/fr_meta_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# If all the books are successfully scraped, convert JSON to CSV

CSV.open("data/csv_test.csv", "w") do |csv|
  # Write header
  csv << ["title", "subtitle", "cover_image", "publisher", "pub_date", "author_primary", "author_secondary", "book_description", "spec_all", "category_all"]

 
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values_at("title", "subtitle", "cover_image", "publisher", "pub_date", "author_primary", "author_secondary", "book_description", "spec_all", "category_all")
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/csv_test.csv"