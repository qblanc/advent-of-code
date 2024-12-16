require_relative "puzzle_solver"

class Day15 < PuzzleSolver
  MOVES = {
    "^" => [0, -1],
    ">" => [1, 0],
    "v" => [0, 1],
    "<" => [-1, 0]
  }

  def initialize
    super
    @warehouse_map = @input.select { |line| line.start_with?("#") }.map(&:chars)
    @big_warehouse_map = @warehouse_map.map(&:dup).map { |line| expand_warehouse(line).flatten(1) }
    @attempted_movements = @input.select { |line| line.start_with?(/\^|>|v|</) }.map(&:chars).flatten(1)
  end

  def first_result
    predict_warehouse_final_state
    boxes_gps_coordinates.sum
  end

  def second_result
    predict_warehouse_final_state(big_map: true)
    boxes_gps_coordinates(big_map: true).sum
  end

  private

  def predict_warehouse_final_state(big_map: false)
    robot_position = starting_coordinates(big_map:)
    map = big_map ? @big_warehouse_map : @warehouse_map
    @attempted_movements.each do |move|
      next_robot_position = next_robot_position(robot_position, move)
      case map[next_robot_position[1]][next_robot_position[0]]
      when "#"
        next
      when "."
        robot_position = move_robot(robot_position, next_robot_position, big_map:)
      else
        robot_position = try_to_move_robot_and_boxes(robot_position, next_robot_position, move, big_map:)
      end
    end
  end

  def try_to_move_robot_and_boxes(robot_position, next_robot_position, move, big_map:)
    boxes_movements = boxes_movements(robot_position, move, big_map:)
    return robot_position if boxes_movements.empty?

    move_boxes(move, boxes_movements, big_map:) unless boxes_movements.first == next_robot_position
    move_robot(robot_position, next_robot_position, big_map:)
  end

  def boxes_movements(robot_position, move, big_map:)
    return next_available_position(robot_position, move, big_map:) if !big_map || ["<", ">"].include?(move)

    x, y = robot_position
    _, b = MOVES[move] # we only use this method for vertical cases, first value is always = 0
    offset = b
    boxes = collect_boxes(x, y, b, offset)
    boxes_movements = valid_boxes_movements(boxes, offset)
    boxes.length == boxes_movements.length ? boxes_movements : []
  end

  def valid_boxes_movements(boxes, offset)
    boxes_movements = []
    boxes.map { |x, y, box_type| boxes_movements << [[x, y],[x, y + offset], box_type] unless @big_warehouse_map[y + offset][x] == "#" }
    boxes_movements
  end

  def collect_boxes(x, y, b, offset)
    boxes = Hash.new { |h, k| h[k] = [] }
    boxes[b] += detect_boxes(x, y + offset) unless detect_boxes(x, y + offset).nil?
    until boxes[b].empty?
      b += offset
      boxes[b - offset].each do |x, y|
        boxes_coordinates = detect_boxes(x, y + offset)
        boxes[b] += boxes_coordinates unless boxes_coordinates.nil?
      end
    end
    boxes.values.flatten(1).uniq
  end

  def detect_boxes(x, y)
    case @big_warehouse_map[y][x]
    when "["
      [[x, y, "["], [x + 1, y, "]"]]
    when "]"
      [[x - 1, y, "["], [x, y, "]"]]
    end
  end

  def next_available_position(robot_position, move, big_map:)
    map = big_map ? @big_warehouse_map : @warehouse_map
    x, y = robot_position
    a, b = MOVES[move]
    offset = a == 0 ? b : a
    while ["O", "[", "]"].include?(map[y + b][x + a])
      a == 0 ? b += offset : a += offset
    end

    map[y + b][x + a] == "." ? [[x + a, y + b]] : []
  end

  def move_robot(robot_position, next_robot_position, big_map:)
    map = big_map ? @big_warehouse_map : @warehouse_map
    map[robot_position[1]][robot_position[0]] = "."
    map[next_robot_position[1]][next_robot_position[0]] = "@"
    next_robot_position
  end

  def move_boxes(move, boxes_movements, big_map:)
    return move_big_warehouse_boxes(move, boxes_movements) if big_map

    x, y = boxes_movements.first
    @warehouse_map[y][x] = "O"
  end

  def move_big_warehouse_boxes(move, boxes_movements)
    if ["<", ">"].include?(move)
      move_big_boxes_horizontally(move, boxes_movements.first)
    else
      move_big_boxes_vertically(boxes_movements)
    end
  end

  def move_big_boxes_horizontally(move, next_available_position)
    x, y = next_available_position
    offset = MOVES[move][0]
    until @big_warehouse_map[y][x - offset] == "@"
      @big_warehouse_map[y][x] = @big_warehouse_map[y][x - offset]
      x -= offset
    end
  end

  def move_big_boxes_vertically(boxes_movements)
    old_positions = boxes_movements.map(&:first)
    new_positions = boxes_movements.map { |box_movement| box_movement[1] }
    old_positions.each { |x, y| @big_warehouse_map[y][x] = "." }
    new_positions.each_with_index { |(x, y), i| @big_warehouse_map[y][x] = boxes_movements[i][2] }
  end

  def next_robot_position(position, move)
    x, y = position
    a, b = MOVES[move]

    [x + a, y + b]
  end

  def starting_coordinates(big_map:)
    map = big_map ? @big_warehouse_map : @warehouse_map
    map.each_with_index do |line, line_index|
      index = line.index("@")
      break [index, line_index] if index
    end
  end

  def boxes_gps_coordinates(big_map: false)
    boxes_coordinates(big_map).map { |x, y| y * 100 + x }
  end

  def boxes_coordinates(big_map)
    boxes_coordinates = []
    map = big_map ? @big_warehouse_map : @warehouse_map
    box_value = big_map ? "[" : "O"
    map.each.with_index do |line, line_index|
      line.each.with_index do |point, index|
        boxes_coordinates << [index, line_index] if point == box_value
      end
    end
    boxes_coordinates
  end

  def expand_warehouse(line)
    line.map do |point|
      case point
      when "#"
        ["#", "#"]
      when "O"
        ["[", "]"]
      when "."
        [".", "."]
      when "@"
        ["@", "."]
      end
    end
  end
end

Day15.solve
