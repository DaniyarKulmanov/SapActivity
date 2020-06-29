require_relative 'read_files'

count = ReadFiles.new

count.start

puts pp count.transaction
