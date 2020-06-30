require_relative 'read_files'

count = ReadFiles.new

count.start

puts 'done' unless count.statistics.nil?
pp count.statistics.first(20)
