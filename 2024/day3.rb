require_relative "puzzle_solver"

VALID_INSTRUCTIONS_FORMAT = /(mul\(\d{1,3},\d{1,3}\))/
INSTRUCTIONS_VALIDITY_SWITCH = /(?:do\(\)|don't\(\))/

class Day3 < PuzzleSolver
  def first_result
    compute(partially_valid_instructions)
  end

  def second_result
    compute(valid_instructions)
  end

  private

  def compute(instructions)
    instructions.map { |instruction| instruction[4..-2].split(",") }.sum { |a, b| a.to_i * b.to_i }
  end

  def partially_valid_instructions
    @partially_valid_instructions ||= @input.join.scan(VALID_INSTRUCTIONS_FORMAT).flatten
  end

  def valid_instructions
    instructions_enabled = true
    @input.join.split(VALID_INSTRUCTIONS_FORMAT).filter_map do |instruction|
      if instruction.match?(INSTRUCTIONS_VALIDITY_SWITCH)
        instructions_enabled = instruction.scan(INSTRUCTIONS_VALIDITY_SWITCH).last == "do()" ? true : false
        nil
      elsif instruction.match?(VALID_INSTRUCTIONS_FORMAT)
        instructions_enabled ? instruction : nil
      else
        nil
      end
    end
  end
end

Day3.solve
