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
require 'open-uri'
require 'awesome_print'
require 'dotenv'
require 'colorize'
require 'csv'
require 'ostruct'
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
    rescue Goodreads::NotFound => error
      puts "#{isbn} not found.".red
    end
  end
end

class ImportIoApi
  # import.io extractor
  @@container = Array.new

  def initialize
    @importio_key = ENV['IMPORTIO_KEY']
  end

  def get_link_to_other_editions(url)
    begin
      response = JSON.parse(open("https://api.import.io/store/connector/b12247b8-536e-42c0-b70f-7751aab79e37/_query?input=webpage/url:#{url}&&_apikey=#{@importio_key}").read)
      return response["results"][0]["othereditionslink"]
    rescue OpenURI::HTTPError => error
      response = error.io
      puts response.status.join(', ').red
    end
  end

  def get_meta_from_other_editions(url)
    begin
      uri = URI.escape("https://api.import.io/store/connector/d0912384-fa66-4f27-a43d-8a96b49a1792/_query?input=webpage/url:#{url}?per_page=100&utf8=✓&sort=date_published&filter_by_format=&&_apikey=#{@importio_key}")
      response = JSON.parse(open(uri).read)
      return response["results"]
    rescue OpenURI::HTTPError => error
      response = error.io
      puts response.status.join(', ').red
    end 
  end

  def serialize(edition)
    OpenStruct.new(
      title: edition["title/_text"],
      pub_date_and_publisher: edition["pub_date_and_publisher"],
      format_and_page: edition["format_and_page"],
      author: edition["author"],
      isbn: edition["isbn"],
      isbn13: edition["isbn13"],
      language: edition["language"],
      image: edition["image"]
    )
  end

  def formats_to_reject
    ["Library Binding", "Kindle Edition", "ebook", "Audiobook", "Unabridged", "Audio"]
  end

  def cleanup(edition)
    book = serialize(edition)
    
    title = book.title
    if book.pub_date_and_publisher != nil
      pub_date = book.pub_date_and_publisher.split(' by ')[0].gsub("Published ", '')
      publisher = book.pub_date_and_publisher.split(' by ')[1]
    else
      pub_date, publisher = nil
    end

    if book.format_and_page != nil
      format = book.format_and_page.split(', ')[0]
      page = book.format_and_page.split(', ')[1]
    else
      format, page = nil
    end

    isbn = book.isbn 
    isbn13 = book.isbn13

    if book.isbn13 and book.isbn13.include? "ISBN13"
      book.isbn13.gsub!("(ISBN13: ", "").gsub!(")", "")
    end

    image = book.image
    author = book.author
    language = book.language

    book_cleaned = OpenStruct.new(
      title: title,
      publisher: publisher,
      pub_date: pub_date,
      format: format,
      page: page,
      isbn: isbn,
      isbn13: isbn13,
      image: image,
      author: author,
      language: language
    )
    

    if formats_to_reject.any? { |format| 
        book_cleaned.title.include? format unless book_cleaned.title.nil? }
      puts "Reject the following!".red
      book_cleaned.message = "REJECT"
    elsif formats_to_reject.any? { |format| 
        book_cleaned.format.include? format unless book_cleaned.format.nil? }
      puts "Reject the following!".red
      book_cleaned.message = "REJECT"
    elsif 
      formats_to_reject.any? { |format| 
        book_cleaned.pub_date.include? format unless book_cleaned.pub_date.nil? }
      puts "Reject the following!".red
      book_cleaned.message = "REJECT"
    else
      # everything looks ok. save.

      puts "OK".blue
      book_cleaned.message = "OK"
    end

    puts "title: #{book_cleaned.title}"
    puts "publisher: #{book_cleaned.publisher}" 
    puts "pub_date: #{book_cleaned.pub_date}"
    puts "format: #{book_cleaned.format}"
    puts "page: #{book_cleaned.page}"
    puts "isbn: #{book_cleaned.isbn}"
    puts "isbn13: #{book_cleaned.isbn13}"
    puts "author: #{book_cleaned.author}"
    puts "image: #{book_cleaned.image}"
    puts "language: #{book_cleaned.language}"
    puts "message: #{book_cleaned.message}"



    # Now, if book_cleaned format is okay, save to hash array otherwise skip

    save_to_array(book_cleaned) if book_cleaned.message == "OK"
  end

  def save_to_array(book)
    ap book.to_h
    @@container << book.to_h
  end

  def self.container
    @@container
  end

end

### CONTROLLER 

gr_search = GoodreadsApi.new.book_by_isbn('9780545123266')


ap link_to_other_editions = ImportIoApi.new.get_link_to_other_editions(gr_search["url"])

other_editions = ImportIoApi.new.get_meta_from_other_editions(link_to_other_editions)


other_editions.each_with_index do |edition, index|
  ImportIoApi.new.cleanup(edition)
  puts "#{index}".yellow
  puts ''
end

ap ImportIoApi.container