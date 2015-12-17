require 'emailhunter'
require 'awesome_print'
require 'dotenv'
require 'retriable'
require 'csv'
require 'colorize'
Dotenv.load


def load_emails
  @email_inputs = []
  File.readlines('data/emailhunter_source.txt').each do |line|
    @email_inputs << line.rstrip
  end
  puts "Loaded #{@email_inputs.size} emails.".blue
end

def verify(email, index)
  Retriable.retriable tries: 3, base_interval: 2 do
    @result = @client.verify(email)
  end

  if @result
    @container << [ email, @result.result, Time.now, index ]
    puts "#{index}: OK".white
  else
    @container << [ email, "n/a", Time.now, index ]
    puts "#{index}: n/a".red
  end
end

def save_to_csv(email, result, time)
  CSV.open("data/emailhunter_results.csv", "a") do |csv|
      csv << [ email, result, time ]
  end
end


# Initialize
@client = EmailHunter.new(ENV['EMAILHUNTER_SECRET'])
@container = []

load_emails

@email_inputs.each_with_index do |email, index|
  puts "#{index + 1} of #{@email_inputs.size}: Queried #{email} ... "

  @threads = []
  @threads << Thread.new {
    verify(email, index)
    sleep 1
  }

end

# Join threads
Thread.list.each do |t|
  t.join if t != Thread.current
end

# Sort threads by index value, otherwise it'll mess up order
@container.sort_by! { |e| e[3] }

#ap @container

# Save results to csv
@container.each do |c|
  save_to_csv(c[0], c[1], c[2])
end


puts "*=*=*=*=*=*=*=*=*=*=*=*=*=*=", "Everything done."
