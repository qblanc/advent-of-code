require_relative "puzzle_solver"

class Day12 < PuzzleSolver
  def first_result
    compute_fencing_price
    @total_fencing_price
  end

  def second_result
    compute_fencing_price_with_discount
    @total_fencing_price_with_discount
  end

  private

  def compute_fencing_price
    @gardens_map = @input.map(&:chars).map(&:dup)
    @region_gardens_list = Hash.new { |h, k| h[k] = { gardens: Set.new(), neighbours: [], sides: 0 }}
    @total_fencing_price = 0
    @total_fencing_price_with_discount = 0
    region_id = 0
    @gardens_map.each_with_index do |line, line_index|
      line.each_with_index do |garden_type, index|
        next if garden_already_processed(garden_type)

        region_perimeter = 0
        region_area = 0
        region_id += 1
        gardens_to_count = Set.new([[line_index, index]])
        @region_gardens_list["#{garden_type}#{region_id}"][:gardens].add([line_index, index])

        while gardens_to_count.any?
          x, y = gardens_to_count.first
          next gardens_to_count.delete([x, y]) if out_of_bounds?([x, y])

          region_area += 1
          region_perimeter += 4
          directions.each do |a, b|
            test_x = x + a
            test_y = y + b
            next if out_of_bounds?([test_x, test_y])

            adjacent_garden = @gardens_map[test_x][test_y]
            gardens_to_count.add([test_x, test_y]) if adjacent_garden == garden_type
            if adjacent_garden.downcase == garden_type.downcase
              region_perimeter -= 1
              @region_gardens_list["#{garden_type}#{region_id}"][:gardens].add([x, y])
            else
              @region_gardens_list["#{garden_type}#{region_id}"][:neighbours] << adjacent_garden.upcase
            end
          end
          @gardens_map[x][y] = garden_type.downcase
          gardens_to_count.delete(gardens_to_count.first)
        end

        @total_fencing_price += region_perimeter * region_area
      end
    end
  end

  def compute_fencing_price_with_discount
    @total_fencing_price_with_discount = 0
    @region_gardens_list.each do |region_id, region|
      @region_gardens_list[region_id][:sides] = number_of_angles(region)
      @total_fencing_price_with_discount += region[:sides] * region[:gardens].length
    end
  end

  def number_of_angles(region)
    return 4 if region[:gardens].length == 1

    number_of_angles = 0
    region[:gardens].each do |x, y|
      directions.push(directions.first).each_cons(2) do |(a1, b1), (a2, b2)|
        number_of_angles += 1 if angle_detected?([x, y], [x + a1, y + b1], [x + a2, y + b2])
      end
    end
    number_of_angles
  end

  def angle_detected?(garden, neighbour_1, neighbour_2)
    acute_angle?(garden, neighbour_1, neighbour_2) || obtuse_angle?(garden, neighbour_1, neighbour_2)
  end

  def acute_angle?(garden, neighbour_1, neighbour_2)
    neighbours_are_different?(garden, neighbour_1) && neighbours_are_different?(garden, neighbour_2)
  end

  def obtuse_angle?(garden, neighbour_1, neighbour_2)
    return if out_of_bounds?(neighbour_1) || out_of_bounds?(neighbour_2)

    x = neighbour_1[0] + neighbour_2[0] - garden[0]
    y = neighbour_1[1] + neighbour_2[1] - garden[1]
    base_garden_type = garden_type(garden)
    garden_type([x, y]) != base_garden_type &&
      base_garden_type == garden_type(neighbour_1) &&
      base_garden_type == garden_type(neighbour_2)
  end

  def neighbours_are_different?(garden_1, garden_2)
    return true if out_of_bounds?(garden_2)

    garden_type(garden_1) != garden_type(garden_2)
  end

  def garden_type(garden)
    @gardens_map[garden[0]][garden[1]]&.upcase
  end

  def garden_already_processed(garden_type)
    garden_type == garden_type.downcase
  end

  def directions
    [[0, 1], [-1, 0], [0, -1], [1, 0]]
  end

  def out_of_bounds?(coordinates)
    x, y = coordinates
    x < 0 || x > max_index || y < 0 || y > max_index
  end

  def max_index
    @max_index ||= @input.length - 1
  end
end

Day12.solve
