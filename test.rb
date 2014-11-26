require 'rubygems'
require 'mechanize'

require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 5*60     # 5 minutes
        end
    end
end


mechanize = Mechanize.new

book_page_urls = []
File.readlines('data/it_get_meta_source.txt').each do |line|
  book_page_urls << line.gsub(' ', '')
end

book_page_urls.each do |url|
  page = mechanize.get(url)
  puts url
  
  # Title
  puts page.at("#productTitle").text.strip
  
  # Publisher
  puts page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Editore:')]").text.gsub('Editore: ', '')
  
  # Pub Date
  puts page.at(".a-size-medium.a-color-secondary.a-text-normal").text.strip
  
  # ISBN-13
  puts page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'ISBN-13:')]").text.gsub('ISBN-13: 978-', '978')
  
  # Series
  if page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Collana:')]")
    puts page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Collana:')]").text.strip
  end
  
  # Language
  if puts page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Lingua:')]")
    puts page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Lingua:')]").text.strip
  end

  # Category
  puts page.at(".//div[not(@id)][not(@style)][contains(concat(' ',normalize-space(@class),' '),\" bucket \")]/div[1][not(@id)][not(@style)][contains(concat(' ',normalize-space(@class),' '),\" content \")]/ul[1][not(@id)][not(@class)][not(@style)]").text.strip

  puts "\n"

end


