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


agent = Mechanize.new

book_page_urls = []
File.readlines('data/it_get_meta_source.txt').each do |line|
  book_page_urls << line.gsub(' ', '')
end

data_row = []

book_page_urls.each do |url|
  page = agent.get(url)
  
  # Url
  puts url
  data_row << url
  
  # Title
  title = page.at("#productTitle").text.strip
  puts title
  data_row << title

  # Author
  if page.at(".//div[not(@style)][@id=\"byline\"][contains(concat(' ',normalize-space(@class),' '),\" a-section a-spacing-micro bylineHidden feature \")]")
    author = page.at(".//div[not(@style)][@id=\"byline\"][contains(concat(' ',normalize-space(@class),' '),\" a-section a-spacing-micro bylineHidden feature \")]").text.gsub('di ', '')
    puts author
    data_row << author
  end
  
  # Publisher
  publisher = page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Editore:')]").text.gsub('Editore: ', '')
  puts publisher
  data_row << publisher
  
  # Pub Date
  pub_date = page.at(".a-size-medium.a-color-secondary.a-text-normal").text.strip
  puts pub_date
  data_row << pub_date

  # ISBN-13
  isbn = page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'ISBN-13:')]").text.gsub('ISBN-13: 978-', '978')
  puts isbn
  data_row << isbn

  # Series
  if page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Collana:')]")
    series = page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Collana:')]").text.strip
    puts series
    data_row << series
  end
  
  # Language
  if page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Lingua:')]")
    language = page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Lingua:')]").text.strip.gsub('Lingua: ', '')
    puts language
    data_row << language
  end

  # Page
  if page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Copertina ')]")
    page = page.at("//*[contains(@class, 'content')]/ul[not(contains(@class,'qpUL'))]/li[contains(., 'Copertina ')]").content
    puts page
    data_row << page
  end

  # Category
 

  puts "\n"

end
