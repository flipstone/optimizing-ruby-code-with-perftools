ENV['PERFTOOLS_TALK_ENV'] = 'test'
require_relative "../boot"

FactoryGirl.find_definitions

RSpec.configure do |c|
  c.before do
    Schema.create
  end

  c.include Factory::Syntax::Methods
end

describe Organization do
  it "works" do
    create(:organization, name: 'FinancialCo').name.should == 'FinancialCo'
  end
end

describe Investment do
  it "works" do
    create(:investment, name: 'New Shoes').name.should == 'New Shoes'
  end
end

describe View do
  it "includes all investments names and costs" do
    investments = 3.times.map { create :investment }

    html = View.render

    investments.each do |investment|
      html.should include "#{investment.name} - $#{investment.cost} - #{investment.organization.name}"
    end
  end

  it "orders investments descending by cost" do
    investments = [100,200,300].map { |cost| create :investment, :cost => cost }

    html = View.render

    html.scan(Regexp.union(investments.map(&:name))).should ==
      investments.sort_by(&:cost).reverse.map(&:name)
  end

  it "lists each org with its nesting level" do
    root       = create :organization
    child      = create :organization, parent: root
    grandchild = create :organization, parent: child

    html = View.render

    html.should match /\s#{root.name}\s/
    html.should match /\s&nbsp;&nbsp;&nbsp;#{child.name}\s/
    html.should match /\s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{grandchild.name}\s/
  end
end
