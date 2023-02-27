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
    @root = build_tree
  end

  def build_tree(array = @array, start_index = 0, end_index = array.length - 1)
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
    return nil if root.nil?

    if key < root.data
      root.left = delete(root.left, key)
    elsif key > root.data
      root.right = delete(root.right, key)
    else
      if root.left.nil? || root.right.nil?
        root = (root.left.nil?) ? root.right : root.left
      else
        successor = find_successor(root.right)
        root.data = successor.data
        root.right = delete(root.right, successor.data)
      end
    end
    return root
  end

  def find_successor(root)
    current = root
    current = current.left until current.left.nil?
    return current
  end

  def find(root = @root, value)
    return nil if root.nil?
    return root if value == root.data

    if value < root.data
      find(root.left, value)
    elsif value > root.data
      find(root.right, value)
    end
  end

  def level_order(root = @root)
    return if root.nil?

    queue = [root]
    result = []
    until queue.empty?
      current = queue.shift
      result << (block_given? ? yield(current) : current.data)
      queue << current.left if current.left
      queue << current.right if current.right
    end
    result
  end

  def level_order_rec(root = @root, result = [], queue = [root], &block)
    return if root.nil?
    
    current = queue.shift
    queue << current.left if current.left
    queue << current.right if current.right
    
    result << (block_given? ? block.call(current) : current.data)

    level_order_rec(queue.first, result, queue, &block) 

    result
  end

  def inorder_rec(root = @root, result = [], &block)
    return if root.nil?
    
    inorder_rec(root.left, result, &block) unless root.left.nil?
    result << (block_given? ? block.call(root) : root.data) 
    inorder_rec(root.right, result, &block) unless root.right.nil?
    result

  end

  def preorder_rec(root = @root, result = [], &block)
    return if root.nil?

    result << (block_given? ? block.call(root) : root.data)
    preorder_rec(root.left, result, &block) unless root.left.nil?
    preorder_rec(root.right, result, &block) unless root.right.nil?
    result
  end

  def postorder_rec(root = @root, result = [], &block)
    return if root.nil?

    postorder_rec(root.left, result, &block) unless root.left.nil?
    postorder_rec(root.right, result, &block) unless root.right.nil?
    result << (block_given? ? block.call(root) : root.data)
    result
  end

  def height(node)
    return 0 if node.nil?
    return [height(node.left), height(node.right)].max + 1
  end
  

  def depth(node = @root, current_depth = 0, target_value)
    return current_depth if node.nil?
  
    if node.data == target_value
      return current_depth
    elsif target_value < node.data
      return depth(node.left, current_depth + 1, target_value)
    else
      return depth(node.right, current_depth + 1, target_value)
    end
  end
  
  def balanced?(root = @root)
    return true if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)

    if (left_height - right_height).abs <= 1 && balanced?(root.left) == true && balanced?(root.right) == true
      return true
    end

    return false
  end

  def rebalance
    @array = inorder_rec
    @root = build_tree(@array)
  end

end

def driver_script
  test_array = (Array.new(15) {rand(1..100)})
  test_tree = Tree.new(test_array)
  p "test_array is: #{test_tree.array}"
  test_tree.pretty_print
  p "Balanced?: #{test_tree.balanced?}"
  p "Level Order: #{test_tree.level_order_rec}"
  p "Preorder: #{test_tree.preorder_rec}"
  p "Inorder: #{test_tree.inorder_rec}"
  p "Postorder: #{test_tree.postorder_rec}"
  p "Add some elements to the tree"
  test_tree.insert(200)
  test_tree.insert(300)
  test_tree.insert(400)
  test_tree.insert(500)
  test_tree.pretty_print
  p "Balanced?: #{test_tree.balanced?}"
  p "Rebalance"
  test_tree.rebalance
  test_tree.pretty_print
  p "Balanced?: #{test_tree.balanced?}"
  
end

# test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# test_tree = Tree.new(test_array)
# test_tree.pretty_print
# p test_tree.root
# test_tree.insert(513)
# test_tree.insert(13)
# test_tree.insert(12)
# test_tree.insert(700)
# test_tree.insert(7005)
# test_tree.insert(73)
# test_tree.delete(9)
# test_tree.delete(4)
# test_tree.pretty_print
# p test_tree.level_order { |el| el.data * 2}
# p test_tree.level_order_rec { |el| el.data * 2}
# p test_tree.find(324)
# p test_tree.inorder_rec { |el| el.data * 2}
# p test_tree.preorder_rec { |el| el.data * 2}
# p test_tree.postorder_rec { |el| el.data * 2}
# p test_tree.height(test_tree.find(23))
# p test_tree.depth(23)
# p test_tree.balanced?
# test_tree.rebalance
# test_tree.pretty_print
# p test_tree.balanced?


driver_script