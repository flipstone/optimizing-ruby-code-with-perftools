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
end
