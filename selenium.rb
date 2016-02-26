require "selenium-webdriver"
require "awesome_print"

profile = Selenium::WebDriver::Firefox::Profile.new
profile['permissions.default.stylesheet'] = 2 # Disable css
profile['permissions.default.image'] = 2 # Disable image
driver = Selenium::WebDriver.for :firefox, profile: profile

pages = []

File.readlines('data/selenium_source.txt', encoding: 'UTF-8').each do |line|
	pages << line.rstrip
end

pages.each do |page|
	driver.navigate.to page

	# divs = driver.find_elements(:css, 'parameter2')

	# divs.each do |div|
	# 	ap div.find_elements(:css, 'li').map(&:text)
	# end
	
	links =	driver.find_elements(:css, 'a.a-link-normal.s-access-detail-page.a-text-normal')
	
	# titles = driver.find_elements(:class, 'a-size-medium')
	links.each do |link|
		puts link.attribute('href')
	end

	ap links.map(&:text)



end

driver.quit