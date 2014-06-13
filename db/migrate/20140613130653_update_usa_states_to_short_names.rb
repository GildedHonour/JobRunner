class UpdateUsaStatesToShortNames < ActiveRecord::Migration
  def change
    updated = 0
    not_updated = 0

    Address.all.each do |address|
      puts "="*60
      puts "Updating an address.id: #{address.id} with the state: #{address.state} of the USA."
      
      state_name_array = Address.country_state_list[0][:usa].select { |x| x.values[0] == address.state }
      if state_name_array.any?
        short_state_name = state_name_array[0].keys[0].downcase
        address.state = short_state_name
        address.save!
        updated += 1
        puts "[OK] Updated, the state is: #{address.state}"
      else
        not_updated += 1
        puts "[WARNING] The address was not updated, the state is: #{address.state}"
      end

      puts "Done! Total: #{Address.all.size}, updated: #{updated}, not updated: #{not_updated}"
      puts "="*60
    end
  end
end