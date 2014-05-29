class Address < ActiveRecord::Base
  extend Enumerize
  include Audited

  has_paper_trail
  belongs_to :addressable, polymorphic: true, touch: true
  enumerize :country, in: [:usa, :canada], default: :usa
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  
  def self.country_state_list
    usa = Country.new("us")
    usa_states = get_states(usa)
    ca = Country.new("ca")
    ca_states = get_states(ca)
    [{ usa: usa_states }, { canada: ca_states }]
  end

  def self.get_country_by_state(short_state_name)
    country = nil
    country_state_list.each do |x|
      x.each do |x1, y1|
        y1.each { |x2| country = x1.to_s if x2.keys[0] == short_state_name.to_s.upcase } 
      end
    end
    
    country
  end

  def self.get_long_state_name(short_state_name)
    long_state_name = nil
    country_state_list.each do |x|
      x.each do |x1, y1|
        y1.each { |x2| long_state_name = x2.values[0] if x2.keys[0] == short_state_name.to_s.upcase } 
      end
    end
    
    long_state_name
  end

  def audit_meta
    summary = [self.address_line_1, self.address_line_2, self.city, self.state, self.zip].compact.join(",")
    {
      item_descriptor: "address '#{summary}' for #{self.addressable.audit_meta[:item_descriptor]}",
      item_root_class: self.addressable.class,
      item_root_object_id: self.addressable.id
    }
  end

  private

  def self.get_states(country)
    country.states.map do |x, y|
      h = Hash.new
      h[x] = y["name"]
      h
    end  
  end
end
