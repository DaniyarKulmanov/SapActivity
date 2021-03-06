require 'csv'

class ReadFiles
  attr_reader :transactions, :users, :dates, :files_data, :users_and_dates
  MASK = /^[A-Z][A-Z0-9]*$/
  BATCH_USERS = %w( WF-BATCH PI-BATCH )
  SAPMSYST = 'SAPMSYST'

  def initialize
    @files_data = []
    @transactions = {}
    @users = {}
    @dates = {}
    @users_and_dates = {}


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
    CSV.open('data/result/users.csv', 'w', col_sep: ';') do |csv|
      collect_results users, csv
    end
    CSV.open('data/result/dates.csv', 'w', col_sep: ';') do |csv|
      collect_results dates, csv
    end
    CSV.open('data/result/users_and_dates.csv', 'w', col_sep: ';') do |csv|
      collect_results users_and_dates, csv
    end
  end

  def conditions(met)
    MASK.match?(met[6]) && BATCH_USERS.none?(met[4]) && met[6] != SAPMSYST
  end

  def collect_data(data)
    @transactions[data[6]] ||= 0
    @transactions[data[6]] += 1
    @users[data[4]] ||= 0
    @users[data[4]] += 1
    @dates[data[1]] ||= 0
    @dates[data[1]] += 1
    @users_and_dates[data[4] + ' - ' + data[1]] ||= 0
    @users_and_dates[data[4] + ' - ' + data[1]] += 1
  end

  def sort_all
    @transactions = @transactions.sort_by{|key, value| value}.reverse
    @users = @users.sort_by{|key, value| value}.reverse
    @users_and_dates = @users_and_dates.sort_by{|key, value| value}.reverse
    @dates = @dates.sort_by{|key, value| value}.reverse
  end

  def collect_results(table, csv)
    table.first(20).each do |key, value|
      csv << [key, value]
    end
  end

end
