require_relative '../lib/empty_file'
require_relative '../lib/offenses'

describe EmptyFile do
  let(:offense) { Offenses.new }
  before { File.write('mock.rb', '') && File.write('mock_line.rb', 'Hello World!') }
  after { File.delete('mock.rb') && File.delete('mock_line.rb') }

  describe '.initialize' do
    it 'raise error if there is no argument' do
      expect { EmptyFile.new }.to raise_error(ArgumentError)
    end

    it 'shold not rise error with a strin an  a class as arguments' do
      expect { EmptyFile.new('bin', offense) }.to_not raise_error(ArgumentError)
    end
  end

  describe '#check_if_empty_file' do
    it 'return return an array with the error message' do
      empty = EmptyFile.new('mock.rb', offense)
      empty.check_if_empty_file
      expect(offense.count_offenses).to eq 2
    end
  end

  describe '#check_last_line' do
    it 'return return an array with the error message' do
      empty = EmptyFile.new('mock_line.rb', offense)
      empty.check_last_line
      expect(offense.count_offenses).to eq 2
    end

    it 'raise error if the file is empty' do
      empty = EmptyFile.new('mock.rb', offense)
      expect { empty.check_last_line }.to raise_error(NoMethodError)
    end

    it 'does not add an offense if the last line ends with a newline' do
      File.write('mock_line_with_newline.rb', "Hello World!\n")
      empty = EmptyFile.new('mock_line_with_newline.rb', offense)
      empty.check_last_line
      expect(offense.count_offenses).to eq 0
      File.delete('mock_line_with_newline.rb')
    end
  end
end
