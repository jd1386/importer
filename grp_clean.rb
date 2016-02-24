require "spreadsheet"
require "csv"
require "awesome_print"


def test_returned_isbns
# Returned group of isbns include isbn prefix queried?
	
	# Read source csv file
	book = Spreadsheet.open('data/publishers.xls', encoding: 'utf-8')
	sheet = book.worksheet 1

	File.open("data/clean_grp_results.txt", "w", encoding: 'utf-8') do |f|

		sheet.each 1 do |row|
			abort if row[6].nil?

			# Otherwise..
			puts row[6].split(', ').include? row[0]
			f.puts row[6].split(', ').include? row[0]
		end

	end
end

def join_related_companies
	book = Spreadsheet.open('data/publishers.xls', encoding: 'utf-8')
	sheet = book.worksheet 1

	
	pair = {}
	isbn_group = []
	pair_all = {}
	
	sheet.each_with_index do |row, index|

		# Previous isbn prefix == New isbn prefix
		if sheet.row(index)[0] == sheet.row(index - 1)[0]
			puts "#{index}: #{sheet.row(index)[0]} same"
			isbn_group << "#{sheet.row(index)[1]} (#{sheet.row(index)[4]})"
			pair = {sheet.row(index)[0] => isbn_group}

		# Previous isbn prefix != New isbn prefix
		else
			puts "#{index}: #{sheet.row(index)[0]} not same"
			isbn_group = []
			isbn_group << "#{sheet.row(index)[1]} (#{sheet.row(index)[4]})"
			pair = {sheet.row(index)[0] => isbn_group}
		end

		pair_all.merge!(pair)

	end
	

	# Write results to CSV
	CSV.open("data/join_related_companies_results.csv", "w") do |row|

		pair_all.each do |key, value|
			row << [key, value.join(', ')]
		end

	end
end



join_related_companies

