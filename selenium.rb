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
	divs = driver.find_elements(:class, 'div.a-row.a-spacing-small')
	# titles = driver.find_elements(:class, 'a-size-medium')
	# links = driver.find_elements(:class, 'a-link-normal')

	ap divs.map(&:text)


end

driver.quit