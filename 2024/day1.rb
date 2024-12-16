require_relative "puzzle_solver"

class Day1 < PuzzleSolver
  def initialize
    super
    @first_list, @second_list = collect_sorted_lists
  end

  def first_result
    compute_distances.sum
  end

  def second_result
    compute_similarity_score.sum
  end

  private

  def collect_sorted_lists
    @input.map { |pair| pair.split(" ").map(&:to_i) }.transpose.map(&:sort)
  end

  def compute_distances
    distances = []

    @first_list.each_with_index do |number, index|
      distances << compute_distance(number, @second_list[index])
    end

    distances
  end

  def compute_distance(first_number, second_number)
    (first_number - second_number).abs
  end

  def compute_similarity_score
    similarity_scores = []

    @first_list.each do |reference_number|
      similarity_scores << reference_number * @second_list.count(reference_number)
    end

    similarity_scores
  end
end

Day1.solve
