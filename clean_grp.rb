require "spreadsheet"
require "awesome_print"


def test_returned_isbns
	# Returned isbns include isbn prefix queried?
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

	sheet.each 1 do |row|
			abort if row[6].nil?
			
			# Otherwise..
			related_companies = []
			puts row[0]
			
	end

end





