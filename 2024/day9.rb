require_relative "puzzle_solver"
require_relative "lib/system_fragmentor"
require_relative "lib/system_compactor"

class Day9 < PuzzleSolver
  def first_result
    fragmented_filesystem = SystemFragmentor.new(filesystem: initial_filesystem).activate
    system_checksum(fragmented_filesystem)
  end

  def second_result
    compacted_filesystem = SystemCompactor.new(filesystem: initial_filesystem).activate
    system_checksum(compacted_filesystem)
  end

  private

  def system_checksum(arr)
    arr.compact.each_with_index.sum { |n, i| n == "." ? 0 : n * i }
  end

  def initial_filesystem
    @filesystem ||= @input.first.chars.map(&:to_i).dup
  end
end

Day9.solve
