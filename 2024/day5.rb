require_relative "puzzle_solver"

class Day5 < PuzzleSolver
  def first_result
    compute_result(valid_updates)
  end

  def second_result
    compute_result(fixed_unvalid_updates)
  end

  private

  def compute_result(updates)
    updates.map { |update| update[update.size / 2] }.sum
  end

  def fixed_unvalid_updates
    unvalid_updates.map do |update|
      fix_update(update)
    end
  end

  def fix_update(update)
    update.reverse.each_with_index do |page_number, index|
      pages_to_prioritize = (update & pages_to_be_printed_before_page(page_number))
      if pages_to_prioritize.any?
        update.delete(page_number)
        update.insert(update.index(pages_to_prioritize.last) + 1, page_number)
      end
    end
    update
  end

  def unvalid_updates
    @unvalid_updates ||= safety_updates - valid_updates
  end

  def valid_updates
    @valid_updates ||= safety_updates.select do |pages_to_update|
      update_is_valid?(pages_to_update)
    end
  end

  def update_is_valid?(pages_to_update)
    pages_to_update.each_with_index do |page_number, index|
      break if (pages_to_update.drop(index + 1) & pages_to_be_printed_before_page(page_number)).any?
    end
  end

  def pages_to_be_printed_before_page(page_number)
    relevant_ordering_rules(page_number).map { |rule| rule[/^\d+/].to_i }
  end

  def relevant_ordering_rules(page_number)
    page_ordering_rules.select { |ordering_rule| ordering_rule.end_with?(page_number.to_s) }
  end

  def page_ordering_rules
    @page_ordering_rules ||= @input[0...input_pivot_index]
  end

  def safety_updates
    @safety_updates ||= @input[(input_pivot_index + 1)..-1].map do |update_instruction|
      update_instruction.split(",").map(&:to_i)
    end
  end

  def input_pivot_index
    @input_pivot_index ||= @input.index("")
  end
end

Day5.solve
