module AddressParamsParser
  extend ActiveSupport::Concern

  def permitted_params_with_country_parsed
    ppwc = permitted_params
    if ppwc["addresses_attributes"]
      ppwc["addresses_attributes"].keys.each do |key|
        st = ppwc["addresses_attributes"][key]["state"].to_sym
        ppwc["addresses_attributes"][key]["country"] = Address.get_country_by_state(st).to_s
      end
    end
    
    ppwc
  end
end