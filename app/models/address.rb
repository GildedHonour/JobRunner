class Address < ActiveRecord::Base
  has_paper_trail

  extend Enumerize
  include Audited

  belongs_to :addressable, polymorphic: true, touch: true
  enumerize :country, in: [:usa, :canada], default: :usa

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  
  def self.country_state_list
    {
      usa: [:alabama, :alaska, :arizona, :arkansas, :california, :colorado, :connecticut, :delaware, 
            :florida, :georgia, :hawaii, :idaho, :illinois, :indiana, :iowa, :kansas, :kentucky, :louisiana, 
            :maine, :maryland, :massachusetts, :michigan, :minnesota, :mississippi, :missouri, :montana, 
            :nebraska, :nevada, :new_hampshire, :new_jersey, :new_mexico, :new_york, :north_carolina,
            :north_dakota, :ohio, :oklahoma, :oregon, :pennsylvania, :rhode_island, :south_carolina, 
            :south_dakota, :tennessee, :texas, :utah, :vermont, :virginia, :washington, :west_virginia, 
            :wisconish, :wyoming],  
      canada: [:ontario, :quebec, :nova_scotia, :new_brunswick, :manitoba, :british_columbia, 
              :prince_edward_island, :saskatchewan, :alberta, :newfoundland_and_labrador]
    }
  end

  def self.get_country_by_state(st)
    country_state_list.select { |k, v| v.include?(st) }.keys[0]
  end

  def audit_meta
    summary = [self.address_line_1, self.address_line_2, self.city, self.state, self.zip].compact.join(",")
    {
      item_descriptor: "address '#{summary}' for #{self.addressable.audit_meta[:item_descriptor]}",
      item_root_class: self.addressable.class,
      item_root_object_id: self.addressable.id
    }
  end
end
