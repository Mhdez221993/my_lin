class EmptyFile
  attr_accessor :file, :class_offense

  def initialize(file, class_offense)
    @file = file
    @class_offense = class_offense
    check_if_empty_file
    call_check_last_line
  end

  def check_if_empty_file
    class_offense.push_offenses(" #{file}:1:1: w: Lint/EmtyFile: Empty file detected") if File.empty?(file)
  end

  def check_last_line
    message = 'C: Layout/TrailingEmptyLines: Final newline missing'
    f = File.readlines(file)
    line = f[f.size - 1]
    class_offense.push_offenses(" #{file}:#{file.size + 1}:#{line.size + 1}: " + message) unless line =~ /\n$/
  end

  private

  def call_check_last_line
    check_last_line unless File.empty?(file)
  end
end
