class SystemCompactor
  def initialize(filesystem:)
    @filesystem = filesystem # filesystem is supposed to be an array of integers
  end

  def activate
    iterate_backwards_on_files_to_print_map
    add_remaining_free_space_to_map

    return unidimensional_array_of_the_compacted_filesystem
  end

  private

  def iterate_backwards_on_files_to_print_map
    files_reversed_with_indices.each do |(file_size, original_index)|
      print_file_to_map(file_size, original_index)
    end
  end

  def print_file_to_map(file_size, original_index)
    available_index = index_for_available_free_space(file_size)
    if file_can_be_moved_leftward?(available_index, original_index)
      move_file_to_free_space(available_index, original_index, file_size)
    else
      add_value_to_map(original_index * 2, original_index, file_size)
    end
  end

  def file_can_be_moved_leftward?(available_index, original_index)
    available_index && original_index > available_index
  end

  def move_file_to_free_space(available_index, original_index, file_size)
    add_value_to_map(available_index * 2 + 1, original_index, file_size)
    add_value_to_map(original_index * 2, ".", file_size)
    decrement_available_free_space(available_index, file_size)
  end

  def add_value_to_map(destination_index, value, file_size)
    compact_filesystem_map[destination_index] += [value] * file_size
  end

  def decrement_available_free_space(available_index, file_size)
    free_space[available_index] = free_space[available_index] - file_size
  end

  def add_remaining_free_space_to_map
    free_space.each_with_index do |size, index|
      next if size == 0

      compact_filesystem_map[index * 2 + 1] += ["."] * size
    end
  end

  def index_for_available_free_space(file_size)
    free_space.index { |free_space_size| free_space_size >= file_size }
  end

  def files_reversed_with_indices
    @files_reversed_with_indices ||= files.each_with_index.to_a.reverse
  end

  def compact_filesystem_map
    @compact_filesystem_map ||= Hash.new { |k, v| [] }
  end

  def files
    @files ||= @filesystem.select.with_index { |_, i| i.even? }
  end

  def free_space
    @free_space ||= @filesystem.select.with_index { |_, i| i.odd? }
  end

  def unidimensional_array_of_the_compacted_filesystem
    @unidimensional_array_of_the_compacted_filesystem ||= compact_filesystem_map.sort.map { |_, v| v }.flatten(1)
  end
end
