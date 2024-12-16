require_relative "lib/christmas_interface"
require "benchmark"

class PuzzleSolver
  class << self
    def solve(**)
      solver = new(**)
      puts Benchmark.measure {
        display_results(solver.first_result, solver.second_result)
      }
    end
  end

  def initialize
    @input = File.read(input_file).split("\n")
  end

  def first_result
    raise NoMethodError
  end

  def second_result; end

  private

  def input_file
    "inputs/input_#{self.class.to_s.delete("Day")}.txt"
  end
end
