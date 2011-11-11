class SampleData
  def self.create
    create_organizations
    create_investments
  end

  def self.create_organizations(level = 3, parent = nil)
    return if level == 0;

    LEVELS[level].each do |name|
      org = Organization.create name: name,
                                parent: parent

      create_organizations level - 1, org
    end
  end

  LEVELS = {
    3 => %w(Corporate),
    2 => %w(Florida Georgia NewYork Ohio Illinois California Iowa),
    1 => %w(North South East West NorthEast SouthWest NorthWest SouthEast)
  }

  def self.create_investments
    orgs = Organization.all

    200.times do
      Investment.create! name: random_name,
                         organization: pick(orgs),
                         cost: random_cost
    end
  end

  def self.random_name
    "#{pick(TYPES)} #{pick(THINGS)} #{pick(PART)}"
  end

  def self.random_cost
    rand(3_000) + 3_00
  end

  def self.pick(array)
    array[rand(array.length)]
  end

  TYPES = %w(New Replacement Refurbish Purchase)
  THINGS = %w(Chair Lamp Table Truck Car Vacuum Sidewalk Computer Projector)
  PART = %w(Leg Shade Tire Engine Uphostlery Belt Sealent Screws Bulb Battery)
end
