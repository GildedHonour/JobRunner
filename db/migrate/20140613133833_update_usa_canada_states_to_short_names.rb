class UpdateUsaCanadaStatesToShortNames < ActiveRecord::Migration
  def change
    updated = 0
    not_updated = 0

    Address.all.each do |address|
      puts "="*60
      puts "[INFO] Trying to update an address.id: #{address.id} with the state: #{address.state} of #{address.country.capitalize}."
      
      country = address.country.to_sym
      index = country == :usa ? 0 : 1
      state_name_array = Address.country_state_list[index][country].select { |x| x.values[0] == address.state }
      if state_name_array.any?
        short_state_name = state_name_array[0].keys[0].downcase
        address.state = short_state_name
        address.save!
        updated += 1
        puts "[OK] Updated, the state is: #{address.state} of #{address.country.capitalize}."
      else
        not_updated += 1
        puts "[WARNING] The address was not updated, the state is: #{address.state} of #{address.country.capitalize}."
      end

      puts "="*60
    end

    puts "Done! Total: #{Address.all.size}, updated: #{updated}, not updated: #{not_updated}"
  end
end