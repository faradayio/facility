module BrighterPlanet
  module Facility
    module Data
      def self.included(base)
        base.instance_eval do
          #set_primary_key :id
          #col :id, :type => :integer
          col :latitude
          col :longitude
          col :zip_code_id, :type => :string
          col :naics_code, :type => :string
          col :sales, :type => :float
          col :square_footage, :type => :float
          col :monthly_electricity_payments, :type => :float
          col :monthly_fuel_payments, :type => :float
          col :monthly_transport_payments, :type => :float
          col :monthly_overall_receivables, :type => :float
          
          data_miner do
            process "TODO" do
              // TODO
            end
          end
        end
      end
    end
  end
end
