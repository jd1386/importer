require "selenium-webdriver"
require "awesome_print"

driver = Selenium::WebDriver.for :firefox

pages = [
	"http://list.jd.com/list.html?cat=1713,3260&page=1&sort=sort_publishtime_desc",
	"http://list.jd.com/list.html?cat=1713,3260&page=2&sort=sort_publishtime_desc",
	"http://list.jd.com/list.html?cat=1713,3260&page=3&sort=sort_publishtime_desc",
	"http://list.jd.com/list.html?cat=1713,3260&page=4&sort=sort_publishtime_desc"
]

pages.each do |page|
	driver.navigate.to page


	book_divs = driver.find_elements(:class, 'gl-item')

	book_divs.each do |div|
		ap div.find_element(:css, 'a').attribute("href")
		
		
	end

end

driver.quit