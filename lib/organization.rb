class Organization < ActiveRecord::Base
  belongs_to :parent, class_name: "Organization"
  has_many :children, class_name: "Organization", foreign_key: :parent_id
  has_many :investments

  def nesting
    return 0 unless parent
    parent.nesting + 1
  end

  def total_investments
    investments.map(&:cost).sum(0) +
    children.map(&:total_investments).sum(0)
  end

  def self.with_cached_relations
    Organization.includes(:investments).tap do |all|
      all.each do |parent|
        parent.extend RelationCache
        parent.children = []

        all.each do |possible_child|
          possible_child.extend RelationCache

          if possible_child.parent_id == parent.id
            possible_child.parent = parent
            parent.children << possible_child
          end
        end
      end
    end
  end

  module RelationCache
    attr_accessor :parent
    attr_accessor :children
  end
end
