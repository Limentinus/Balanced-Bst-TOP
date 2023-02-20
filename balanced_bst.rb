class Node
  include Comparable
  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  def initialize(array)
    @array = array
    root =
  end

  def build_tree(array)
    sorted_array = array.uniq.sort
    p sorted_array
  end
end