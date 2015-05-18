require 'date'

dates_to_fix = []
# Load dates to fix
File.readlines('data/fix_date_source.txt').each do |line|
	dates_to_fix << line.rstrip
end


# Write the results to file
File.open('data/fix_date_results.txt', 'w') do |f|
	dates_to_fix.each do |date|
		
			#fixed_date = Date.strptime(date, '%Y-%m-%d')
			#fixed_date = Date.strptime(date, '%b-%y')
			fixed_date = Date.strptime(date, '%Y.%m.%d') # Netherlands
		
		puts fixed_date
		f.puts fixed_date
	end
end

