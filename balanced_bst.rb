class Node
  include Comparable
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :array, :root
  def initialize(array)
    @array = array.uniq.sort
    @end_index = @array.length - 1
    @start_index = 0
    @root = build_tree
  end

  def build_tree(array = @array, start_index = @start_index, end_index = @end_index)
    return if start_index > end_index

    root = (start_index + end_index) / 2
    node = Node.new(array[root])
    node.left = build_tree(array, start_index, root - 1)
    node.right = build_tree(array, root + 1, end_index)
    return node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(root = @root, key)
    if root.nil? 
      root = Node.new(key)
      return root
    end
    p root.data
    if key < root.data
      root.left = insert(root.left, key)
    elsif key > root.data
      root.right = insert(root.right, key)
    else
      # key is equal to root.data, do nothing
    end
    return root
  end

  def delete(root = @root, key)
    if root.nil?
      return root
    end
  end

end

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
test_tree = Tree.new(test_array)
test_tree.pretty_print
# p test_tree.root
test_tree.insert(513)
test_tree.insert(13)
test_tree.pretty_print
