class SystemFragmentor
  def initialize(filesystem:)
    @filesystem = filesystem # filesystem is supposed to be an array of integers
  end

  def activate
    expand_filesystem
    fragment_filesystem

    return fragmented_filesystem
  end

  private

  def expand_filesystem
    current_file_id = 0
    @filesystem.each_with_index do |n, i|
      n.to_i.times do
        expanded_filesystem.push(i.even? ? current_file_id : ".")
      end
      current_file_id += 1 if i.even?
    end
  end

  def expanded_filesystem
    @expand_filesystem ||= []
  end

  def fragment_filesystem
    expanded_filesystem.each_with_index do |file, index|
      next unless free_space?(file)

      replace_free_space_by_trailing_file(index)
    end
  end

  def free_space?(file)
    file == "."
  end

  def replace_free_space_by_trailing_file(index)
    fragmented_filesystem.slice!(index)
    new_value = fragmented_filesystem.slice!(-1)
    while new_value == "."
      new_value = fragmented_filesystem.slice!(-1)
    end
    fragmented_filesystem.insert(index, new_value)
  end

  def fragmented_filesystem
    @fragmented_filesystem ||= expanded_filesystem
  end
end
