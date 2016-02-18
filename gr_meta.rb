<<-COMMENT

Goal:: isbn => meta => db

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
      @client.book_by_isbn(isbn)
      get_meta(@client.book_by_isbn(isbn))
    rescue Goodreads::NotFound => error
      puts "#{isbn} not found.".red
    end
  end

  def clean_pub_date(year, month, day)
    if month.nil? || day.nil?
      Chronic.parse "#{year}-1-1"
    else
      Chronic.parse "#{year}-#{month}-#{day}"
    end
  end

  def merge_name_and_role(name, role)
    if role.nil?
      name.concat(" (Author)")
    else
      name.concat(" (#{role})")
    end
    
  end

  def clean_authors(authors)
    array = []
    if authors["author"].is_a? Array # multiple authors
      authors["author"].each do |author|
        array << merge_name_and_role(author["name"], author["role"])
      end
      return array
    else # single author
      author = authors["author"]
      array << merge_name_and_role(author["name"], author["role"])
    end
  end

  def clean_language(language_code)
    case language_code 
      when nil
        'English'
      when 'eng'
        'English'
      when 'dan'
        'Danish'
      else
        'Something Else'
      end

  end

  def get_meta(response)
    ap response
    hash = {}

    hash[:title] = response["title"]
    hash[:original_title] = response["work"]["original_title"]
    hash[:isbn] = response["isbn"]
    hash[:isbn13] = response["isbn13"]
    hash[:image_url] = response["image_url"]
    hash[:pub_date] = clean_pub_date(response["publication_year"], response["publication_month"], response["publication_day"])
    hash[:publisher] = response["publisher"]
    hash[:language_code] = response["language_code"]
    hash[:language] = clean_language(response["language_code"])
    hash[:description] = response["description"]
    hash[:num_pages] = response["num_pages"]
    hash[:format] = response["format"]
    hash[:url] = response["url"]
    hash[:authors] = clean_authors(response["authors"])
    
    return hash
  end


end


class MyScraper

  def get_meta(url)
    begin
      response = HTTParty.get(url)
      @doc = Nokogiri::HTML(response.body) { |config| config.noblanks }
      parse
 
    rescue OpenURI::HTTPError => error
      response = error.io
      puts response.status.join(', ').red
    end 
  end

  def formats_to_reject
    ["Library Binding", "Kindle Edition", "ebook", "Audiobook", "Unabridged", "Audio"]
  end

  def clean_title_and_series(raw)
    if raw.include? '('
      @title = raw.split('(')[0].strip
      @series = raw.split('(')[1].gsub(")", "")
    else
      @title = raw
      @series = ''
    end
  end

  def clean_pub_date_and_publisher(pub_date_and_publisher)
    if pub_date_and_publisher.present?
      if pub_date_and_publisher.include? 'Published'
        @pub_date = pub_date_and_publisher.split(' by ')[0].gsub!('Published', '')
        if @pub_date.size > 4
          @pub_date = Chronic.parse(@pub_date).to_date
        else # Only year is present
          @pub_date.concat('-01-01')
        end
        @publisher = pub_date_and_publisher.split(' by ')[1].split("\n")[0]
      elsif pub_date_and_publisher.include? 'Expected publication:'
        @pub_date = pub_date_and_publisher.split(' by ')[0].gsub!('Expected publication:', '')
        @pub_date = Chronic.parse(@pub_date).to_date
        @publisher = pub_date_and_publisher.split(' by ')[1].split("\n")[0]
      end
    else
      ''
    end
  end

  def clean_pub_date(raw_pub_date)
    if raw_pub_date.include? "Published"
      Chronic.parse(raw_pub_date.gsub("Published ", ""))
    elsif raw_pub_date.include? "Expected publication"
      Chronic.parse(raw_pub_date.gsub("Expected publication: ", ""))
    end
  end

  def clean_authors(raw_authors)
    @authors = []

    raw_authors.css("span[itemprop='name']").each do |author|
      @authors << author.text
    end

    @authors
  end

  def clean_isbns(raw_isbns)
    cleaned = raw_isbns.gsub(/\s+ /, "").strip
    if cleaned.include? '(ISBN13: '
      isbn13 = cleaned.split('(ISBN13: ')[1].gsub(')', '')
    else
      cleaned
    end
  end

  def clean_description(description)
    if description.present?
      if description.include? '...more'
        description.gsub!('...more', '').strip
      else
        description
      end
    else
      ''
    end
  end

  def clean_language(language)
    if language.blank? # English titles usually don't have language field
      'English'
    else # Regular case
      if language == 'Greek, Modern (1453-)'
        'Greek'
      else
        language
      end
    end
  end

  def clean_page(page)
    if page.nil?
      ''
    else
      if page.include? "pages" 
        page.gsub!(" pages", "")
      else
        page
      end
    end
  end

  def parse

      hash = {}


      hash[:description] = clean_description(@doc.css("div#description.readable.stacked").text.strip)
      
      return hash
  end

  

end



### NEW CONTROLLER USING HTTPARTY AND NOKOGIRI

ap GoodreadsApi.new.book_by_isbn('9783314200250')
