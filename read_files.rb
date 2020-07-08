require 'csv'

class ReadFiles
  attr_reader :transactions, :be, :dates
  MASK = /^[A-Z][A-Z0-9]*$/
  BATCH_USERS = %w( WF-BATCH PI-BATCH )
  SAPMSYST = 'SAPMSYST'

  def initialize
    @files_data = []
    @transactions = {}
    @be = {}
    @dates = {}
  end

  def start
    read_files
    convert_data_to_single_array
    extract_files
    sort_all
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

  def extract_files
    @files_data.each do |line|
    begin
      file_line = line.split
    rescue ArgumentError
      next
    end
      collect_data file_line if conditions file_line
    end
  end

  def write_to_csv_file
    CSV.open('data/result/transactions.csv', 'w', col_sep: ';') do |csv|
      collect_results transactions, csv
    end
    CSV.open('data/result/be.csv', 'w', col_sep: ';') do |csv|
      collect_results be, csv
    end
    CSV.open('data/result/dates.csv', 'w', col_sep: ';') do |csv|
      collect_results dates, csv
    end
  end

  def conditions(met)
    MASK.match?(met[6]) && BATCH_USERS.none?(met[4]) && met[6] != SAPMSYST
  end

  def collect_data(data)
    @transactions[data[6]] ||= 0
    @transactions[data[6]] += 1
    @be[data[4][0..2]] ||= 0
    @be[data[4][0..2]] += 1
    @dates[data[1]] ||= 0
    @dates[data[1]] += 1
  end

  def sort_all
    @transactions = @transactions.sort_by{|key, value| value}.reverse
    @be = @be.sort_by{|key, value| value}.reverse
  end

  def collect_results(table, csv)
    table.each do |key, value|
      csv << [key, value]
    end
  end

end
