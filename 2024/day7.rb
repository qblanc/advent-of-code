require_relative "puzzle_solver"

class Day7 < PuzzleSolver
  def first_result
    evaluate_equations
    @valid_results.sum
  end

  def second_result
    evaluate_equations(with_concatenation: true)
    @valid_results.sum
  end

  private

  def evaluate_equations(with_concatenation: false)
    @valid_results = []

    formatted_input.each do |equation|
      result = equation.slice!(0)
      success = test_all_combinations(equation, result)
      test_with_concatenation(equation, result) if with_concatenation && success != "success"
    end
  end

  def test_all_combinations(equation, result)
    ["+", "*"].repeated_permutation(equation.length - 1).each_with_index do |operators, index|
      if equation.inject { |acc, num| operators.slice!(0) == "+" ? acc + num : acc * num } == result
        @valid_results << result
        break "success"

      end
    end
  end

  def test_with_concatenation(equation, result)
    ["+", "*", "<<"].repeated_permutation(equation.length - 1).each do |operators|
      test_equation = equation.zip(operators).flatten.compact

      while test_equation.length > 1
        operation = test_equation.slice!(0..2)
        operator = operation [1]
        partial_result = if operator == "<<"
                          [operation[0], operation[2]].join.to_i
                        elsif operator == "+"
                          operation[0] + operation[2]
                        else
                          operation[0] * operation[2]
                        end
        test_equation.insert(0, partial_result)
        break if test_equation.first > result

      end
      if test_equation.first == result
        @valid_results << result
        break

      end
    end
  end

  def formatted_input
    @input.map { |equation| equation.gsub(":", "").split(" ").map(&:to_i) }
  end
end

Day7.solve
