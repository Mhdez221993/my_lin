#!/usr/bin/env ruby
require 'find'
require 'colorize'
require_relative '../lib/offenses'
require_relative '../lib/empty_file'
require_relative '../lib/trailing_space'
require_relative '../lib/indentation'

INSPECTING_MSG = " Inspecting %<file_count>d files".freeze
OFFENSES_MSG = ' Offenses:'.freeze
RESULT_MSG = " %<file_count>d files inspected, %<offense_count>s detected".freeze

def inspect_files(files, class_offense)
  files.each do |file|
    EmptyFile.new(file, class_offense)
    TrailingSpace.new(file, class_offense)
    Indentation.new(file, class_offense)
  end
end

def print_results(files, class_offense)
  num = class_offense.count_offenses
  class_offense.print_offenses
  puts "\n"
  puts format(RESULT_MSG, file_count: files.size, offense_count: num.positive? ? "#{num} offense".red : 'no offense'.green)
end

def main
  class_offense = Offenses.new
  files = ARGV.empty? ? Dir["**/*.rb"] : ARGV
  puts format(INSPECTING_MSG, file_count: files.size)
  puts "\n"
  puts OFFENSES_MSG
  inspect_files(files, class_offense)
  puts "\n"
  print_results(files, class_offense)
end

main if __FILE__ == $PROGRAM_NAME
