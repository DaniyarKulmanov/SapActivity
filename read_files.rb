class ReadFiles
  attr_reader :transaction


  def initialize
    @transaction = []
  end

  def start
    @transaction = open_files
    @transaction.flatten!
    @transaction.sort!
  end

  def open_files
    array = []
    Dir.glob('data/*.txt').each do |filename|
      File.open(filename) do |file|
        array << file.readlines
      end
    end
    array
  end

  def count_transaction(file_data)
    file_data.each do |line|
      arr = line.split
      arr[6]
    end
  end

  def write_to_file(statistic)
    # IO.write("data/test_100.txt", array.join("\n"))
  end

end
