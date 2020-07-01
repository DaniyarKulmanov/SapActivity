class ReadFiles
  attr_reader :statistics
  MASK = /^[A-Z][A-Z0-9]*$/

  def initialize
    @files_data = []
    @statistics = {}
  end

  def start
    open_files
    convert_data_to_single_array
    count_transactions
    write_to_file
  end

  private

  def open_files
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
      arr = line.split
    rescue ArgumentError
      next
    end
      transaction = arr[6]
      if MASK.match?(transaction)
        @statistics[transaction] ||= 0
        @statistics[transaction] += 1
      end
    end
  end

  def write_to_file
    @statistics = @statistics.sort_by{|key, value| value}.reverse
    IO.write("data/result/result.txt", @statistics)
  end

end
