module Vswiki

  # a simple helper class for building a tree structure for
  # representing nested lists
  class ListNode
    attr_accessor :text, :depth, :type, :parent, :children

    def initialize(text, depth, type)
      @text = text
      @depth = depth
      @type = type
      @parent = nil
      @children = []
    end

    def add_child(child)
      @children << child
      child.parent = self
    end
  end
end
