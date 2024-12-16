require_relative "puzzle_solver"

class Day13 < PuzzleSolver
  def first_result
    cheapest_claw_strategy
  end

  def second_result
    cheapest_claw_strategy(gigantic_machines: true)
  end

  private

  def cheapest_claw_strategy(gigantic_machines: false)
    cheapest_strategy = 0
    machines_configurations.values.each do |machine_config|
      x1, y1 = machine_config[:button_a]
      x2, y2 = machine_config[:button_b]
      sum_x, sum_y = machine_config[:prize]
      sum_x += 10000000000000 if gigantic_machines
      sum_y += 10000000000000 if gigantic_machines
      valid_combination = compute_optimal_combination(x1, y1, x2, y2, sum_x, sum_y)
      cheapest_strategy += compute_combination_price(valid_combination) unless valid_combination.empty?
    end
    cheapest_strategy
  end

  def compute_optimal_combination(ax, ay, bx, by, px, py)
    # Cramer's rule
    # d = |ax bx| , a = |px bx| / d , b = |ax py| / d
    #     |ay by|       |py by|           |ay py|
    d = ax * by - bx * ay # determinant
    return [] if(d == 0) # skip parallel lines

    a = (px * by - py * bx) / (d*1.0)
    b = (py * ax - px * ay) / (d*1.0)
    return [] unless a == a.floor && b == b.floor # skip non-integer solution

    return [] if a < 0 || b < 0 # skip negative solution

    [a.floor, b.floor]
  end

  def compute_combination_price(valid_combination)
    a, b = valid_combination
    a * 3 + b
  end

  def machines_configurations
    @machines_configurations ||= collect_machines_configurations
  end

  def collect_machines_configurations
    machines_configurations = Hash.new { |h, k| h[k] = {} }
    machine_id = 1
    @input.each do |line|
      instructions = line.scan(/(\d+)/).map(&:first).map(&:to_i)
      if line.start_with?("Button A")
        machines_configurations[machine_id][:button_a] = instructions
      elsif line.start_with?("Button B")
        machines_configurations[machine_id][:button_b] = instructions
      elsif line.start_with?("Prize")
        machines_configurations[machine_id][:prize] = instructions
      else
        machine_id += 1
      end
    end
    machines_configurations
  end
end

Day13.solve
