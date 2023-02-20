class Node
  include Comparable
  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end
end