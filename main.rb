require_relative 'read_files'

count = ReadFiles.new

count.start

pp count.statistics
