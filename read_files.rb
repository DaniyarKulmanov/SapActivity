require 'csv'

class ReadFiles
  attr_reader :statistics
  MASK = /^[A-Z][A-Z0-9]*$/
  BATCH_USERS = %w( WF-BATCH PI-BATCH )

  def initialize
    @files_data = []
    @statistics = {}
  end

  def start
    read_files
    convert_data_to_single_array
    count_transactions
    write_to_csv_file
  end

  private

  def read_files
    Dir.glob('data/*.txt').each do |filename|
      File.open(filename) do |file|
        @files_data << file.readlines
      end
    end
  end

  def convert_data_to_single_array
    @files_data.flatten!
  end

  def count_transactions
    @files_data.each do |line|
    begin
      file_line = line.split
    rescue ArgumentError
      next
    end
      transaction = file_line[6]
      if conditions file_line
        @statistics[transaction] ||= 0
        @statistics[transaction] += 1
      end
    end
    @statistics = @statistics.sort_by{|key, value| value}.reverse
  end

  def write_to_csv_file
    CSV.open('data/result/result.csv', 'w', col_sep: ';') do |csv|
      @statistics.each do |transaction_name, count|
        csv << [transaction_name, count]
      end
    end
  end

  def conditions(data)
    MASK.match?(data[6]) && BATCH_USERS.none?(data[4])
  end

  def collect_data(data)
    
  end

end
