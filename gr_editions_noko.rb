<<-COMMENT

Goal:: isbn => other editions => db

 1. Get book's goodreads page url, using gr api (find_by_isbn method)
 2. Get link to other editions, using import.io
 3. Add additional required query strings
  => ?per_page=100&expanded=true&sort=date_published&utf8=%E2%9C%93
 4. Get meta data from all the editions listed, using import.io
 5. Clean the raw data

 Additional steps afterwards?
 6. Extract isbn out of cleaned data and query to Amazon
 7. Get meta data from there
 8. Save it to our database

COMMENT

require 'goodreads'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'dotenv'
require 'colorize'
require 'csv'
require 'ostruct'
require 'chronic'
Dotenv.load

class GoodreadsApi
  
  Goodreads.configure(
    :api_key => ENV["GOODREADS_KEY"],
    :api_secret => ENV["GOODREADS_SECRET"]
  )

  def initialize
    @client = Goodreads::Client.new
  end

  def book_by_isbn(isbn)
    begin 
      @client.book_by_isbn(isbn)["work"]["id"]
    rescue Goodreads::NotFound => error
      puts "#{isbn} not found.".red
    end
  end
end


class MyScraper
  @container = []

  def get_meta_from_other_editions(url)
    begin
      response = HTTParty.get(url)
      @doc = Nokogiri::HTML(response.body) { |config| config.noblanks }
      parse
      ap @container
    rescue OpenURI::HTTPError => error
      response = error.io
      puts response.status.join(', ').red
    end 
  end

  def formats_to_reject
    ["Library Binding", "Kindle Edition", "ebook", "Audiobook", "Unabridged", "Audio"]
  end

  def clean_pub_date(raw_pub_date)
    if raw_pub_date.include? "Published"
      Chronic.parse(raw_pub_date.gsub("Published ", ""))
    elsif raw_pub_date.include? "Expected publication"
      Chronic.parse(raw_pub_date.gsub("Expected publication: ", ""))
    end
  end

  def clean_authors(raw_authors)
    if raw_authors.include? "Author(s):"
      raw_authors.gsub("Author(s):", "").gsub(/\s+ /, "").strip
    else
      raw_authors
    end
  end

  def clean_isbns(raw_isbns)
    cleaned = raw_isbns.gsub(/\s+ /, "").strip
    if cleaned.include? '(ISBN13: '
      isbn13 = cleaned.split('(ISBN13: ')[1].gsub(')', '')
    else
      cleaned
    end
  end

  def parse
    @container = []

    rows = @doc.css(".elementList.clearFix")
    rows.each do |row|
      hash = {}

      hash[:cover_image] = row.css("img")
      
      row.css(".editionData").each do |edition|
        hash[:url] = "https://www.goodreads.com" + edition.css(".dataRow")[0].css("a.bookTitle").map { |link| link['href'] }.first
        hash[:title] = edition.css(".dataRow")[0].text.strip
        hash[:pub_date] = clean_pub_date(edition.css(".dataRow")[1].text.split("by ")[0].strip)
        hash[:publisher] = edition.css(".dataRow")[1].text.strip.split("by ")[1]
        hash[:binding] = edition.css(".dataRow")[2].text.gsub(/^$\n/,'').strip.split(", ")[0]
        hash[:page] = edition.css(".dataRow")[2].text.gsub(/^$\n/,'').strip.split(", ")[1]


        edition.css(".moreDetails.hideDetails").each do |hidden_meta|
          hash[:authors] = clean_authors(hidden_meta.css(".dataRow")[0].text)
          #hash[:isbn] = hidden_meta.css(".dataRow")[1].text.gsub(/^$\n/,'').strip

          # Isbns
          hidden_meta.css(".dataRow").css(".dataTitle").each_with_index do |e, index|
            if e.text.strip.include? 'ISBN'
              hash[:isbn] = clean_isbns(hidden_meta.css(".dataRow").css(".dataValue")[index].text)
            elsif e.text.strip.include? 'Edition language:'
              hash[:language] = hidden_meta.css(".dataRow").css(".dataValue")[index].text.strip
            end
          end

        end
        
      end

      # Final judge to decide which to add or not
      @container << hash unless formats_to_reject.include? hash[:binding]        
      
    end
  end

end



### NEW CONTROLLER USING HTTPARTY AND NOKOGIRI

ap work_id = GoodreadsApi.new.book_by_isbn('9780399173301')
ap other_editions_url = "https://www.goodreads.com/work/editions/#{work_id}?per_page=100"
other_editions = MyScraper.new.get_meta_from_other_editions(other_editions_url)