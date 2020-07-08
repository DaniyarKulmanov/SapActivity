require_relative 'read_files'

count = ReadFiles.new

count.start

puts 'done' unless count.transactions.nil?
pp count.transactions.first(20)
pp count.be.first(20)
