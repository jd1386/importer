<<-COMMENT

COMMENT

require "selenium-webdriver"
require 'awesome_print'
require 'csv'

recent_pages = []
links = []

File.readlines('recent_source.txt', encoding: 'UTF-8').each do |line|
	recent_pages << line.rstrip
end


driver = Selenium::WebDriver.for :firefox


recent_pages.each_with_index do |recent_page, index|
	print "Page #{index + 1} ... "

	driver.navigate.to recent_page

	book_divs = driver.find_elements(:class, 'gl-item')


	book_divs.each do |div|
		CSV.open('recent_results.csv', 'a') do |csv|
			ap link = div.find_element(:css, 'a').attribute("href")
			csv << [link, driver.current_url]
		end
	end

	print "DONE\n"
end

driver.quit