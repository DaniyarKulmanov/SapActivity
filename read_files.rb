class ReadFiles
  attr_reader :statistics


  def initialize
    @files_data = []
    @statistics = {}
  end

  def start
    open_files
    @files_data.flatten!
    count_transaction
  end

  def open_files
    Dir.glob('data/*.txt').each do |filename|
      File.open(filename) do |file|
        @files_data << file.readlines
      end
    end
  end

  def count_transaction
    @files_data.each do |line|
      arr = line.split
      transaction = arr[6]
      if /^[A-Z][A-Z0-9]*$/.match?(transaction)
        @statistics[transaction] ||= 0
        @statistics[transaction] += 1 
      end
    end
  end

  def write_to_file(statistic)
    # IO.write("data/test_100.txt", array.join("\n"))
  end

end
