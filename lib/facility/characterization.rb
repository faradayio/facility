module BrighterPlanet
  module Facility
    module Characterization
      def self.included(base)
        base.characterize do
          has :sales
          has :square_footage
          has :monthly_electricity_payments
          has :monthly_fuel_payments
          has :monthly_transport_payments
          has :monthly_overall_receivables

          has :supplies
          has :zip_code
          has :mecs_energy

          has :electricity_usage
          has :residual_fuel_oil_usage
          has :natural_gas_usage
          has :lpg_usage
          has :distillate_fuel_oil_usage
        end
      end
    end
  end
end
