require "json"
require "csv"

json_file = JSON.parse(File.open("test.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length

puts json_page_length
puts json_book_per_page_length


CSV.open("data/test.csv", "w") do |csv|
	i = 0
	  n = 0

	  (i...json_page_length).each do 
	    (n...json_file[i].length).each do 
	      if json_file[i].length == 0
	      	csv << ",, error"
	      	puts "error"
	    	else
		      csv << json_file[i][n].values_at("book_page_url", "isbn", "title", "subtitle", "cover_image", "publisher", "pub_date", "author_primary", "author_secondary", "awards", "book_description", "spec_all", "category_all")
		    end
		      n += 1

	    end
	    n = 0
	    i += 1
	  end
end