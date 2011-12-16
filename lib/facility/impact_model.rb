# Copyright 2011 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Facility impact model
# This model is used by the [Brighter Planet](http://brighterplanet.com) [CM1 web service](http://impact.brighterplanet.com) to calculate the TODO, such as energy use and greenhouse gas emissions.

##### Timeframe
# The model calculates impacts that occured during a particular time period (`timeframe`).
# For example if the `timeframe` is February 2010, a Facility that occurred (`date`) on February 15, 2010 will have impacts, but a Facility that occurred on January 31, 2010 will have zero impacts.
#
# The default `timeframe` is the current calendar year.

##### Calculations
# The final impacts are the result of the calculations below. These are performed in reverse order, starting with the last calculation listed and finishing with the greenhouse gas emissions calculation.
#
# Each calculation listing shows:
#
# * value returned (*units of measurement*)
# * description of the value
# * calculation methods, listed from most to least preferred
#
# Some methods use `values` returned by prior calculations. If any of these `values` are unknown the method is skipped.
# If all the methods for a calculation are skipped, the value the calculation would return is unknown.

##### Standard compliance
# When compliance with a particular standard is requested, all methods that do not comply with that standard are ignored.
# Thus any `values` a method needs will have been calculated using a compliant method or will be unknown.
# To see which standards a method complies with, look at the `:complies =>` section of the code in the right column.
#
# Client input complies with all standards.

##### Collaboration
# Contributions to this impact model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.

require 'falls_back_on'

module BrighterPlanet
  module Facility
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # *The greenhouse emissions during `timeframe`.*
          committee :impact do
            quorum 'from energy sources',
              :appreciates => [:electricity_impact, :residual_fuel_oil_impact, :natural_gas_impact, :lpg_impact, :distillate_fuel_oil_impact] do |characteristics|
              score = nil
              [:electricity_impact, :residual_fuel_oil_impact, :natural_gas_impact, :lpg_impact, :distillate_fuel_oil_impact].each do |impact|
                if characteristics[impact]
                  score ||= 0
                  score += characteristics[impact] 
                end
              end
              score
            end
            quorum 'from default' do
              1000 # TODO: delete?
            end
          end

          committee :electricity_impact do
            quorum 'from electricity usage and electricity emission factor', :needs => [:electricity_usage, :electricity_emission_factor] do |characteristics|
              characteristics[:electricity_usage] * characteristics[:electricity_emission_factor]
            end
          end
          committee :electricity_usage do
            quorum 'from monthly electricity payments', :needs => [:monthly_electricity_payments] do |characteristics|
              characteristics[:monthly_electricity_payments] / 0.10  # TODO: look up regional electricity cost
            end
            quorum 'from default' do
              100000  # TODO look up average industrial electricity usage
            end
          end

          committee :residual_fuel_oil_impact do
            quorum 'from residual fuel oil usage', :needs => :residual_fuel_oil_usage do |characteristics|
              co2_per_l = FuelType.find_by_name('Residual Fuel No. 5').emission_factor
              characteristics[:residual_fuel_oil_usage] * co2_per_l
            end
          end
          committee :residual_fuel_oil_usage do
            quorum 'from supplies', :needs => :supplies do |characteristics|
              if supply = characteristics[:supplies].find { |s| s.supplier.residual_fuel_oil_supplier? }
                # TODO look up average monthly price
                supply.monthly_overall_trade / 3.98
              end
            end
            quorum 'from MECS energy ratios', :needs => [:mecs_energy, :monthly_fuel_payments] do |characteristics|
              ratio = characteristics[:mecs_energy].fuel_ratios[:residual_fuel_oil]
              characteristics[:monthly_fuel_payments] * ratio
            end
          end

          committee :natural_gas_impact do
            quorum 'from residual fuel oil usage', :needs => :natural_gas_usage do |characteristics|
              co2_per_cubic_m = FuelType.find_by_name('Commercial Natural Gas').emission_factor
              characteristics[:natural_gas_usage] * (co2_per_cubic_m / 28.316846592)
            end
          end
          committee :natural_gas_usage do
            quorum 'from supplies', :needs => :supplies do |characteristics|
              if supply = characteristics[:supplies].find { |s| s.supplier.natural_gas_supplier? }
                supply.monthly_overall_trade / 3.98  # $ / ($/MCF) = MCF
              end
            end
            quorum 'from MECS energy ratios', :needs => [:mecs_energy, :monthly_fuel_payments] do |characteristics|
              ratio = characteristics[:mecs_energy].fuel_ratios[:natural_gas]
              characteristics[:monthly_fuel_payments] * ratio
            end
          end

          committee :lpg_impact do
            quorum 'from LPG usage', :needs => :lpg_usage do |characteristics|
              co2_per_l = FuelType.find_by_name('LPG (non-energy use)').emission_factor
              characteristics[:lpg_usage] * co2_per_l
            end
          end
          committee :lpg_usage do
            quorum 'from supplies', :needs => :supplies do |characteristics|
              if supply = characteristics[:supplies].find { |s| s.supplier.lpg_supplier? }
                usage = supply.monthly_overall_trade / 1.50  # $ / ($/gal) = gal
                usage / 0.264  # in L
              end
            end
            quorum 'from MECS energy ratios', :needs => [:mecs_energy, :monthly_fuel_payments] do |characteristics|
              ratio = characteristics[:mecs_energy].fuel_ratios[:lpg_and_ngl]
              characteristics[:monthly_fuel_payments] * ratio
            end
          end

          committee :distillate_fuel_oil_impact do
            quorum 'from distillate fuel oil usage', :needs => :distillate_fuel_oil_usage do |characteristics|
              co2_per_l = FuelType.find_by_name('Distillate Fuel No. 1').emission_factor
              characteristics[:distillate_fuel_oil_usage] * co2_per_l
            end
          end
          committee :distillate_fuel_oil_usage do
            quorum 'from supplies', :needs => :supplies do |characteristics|
              if supply = characteristics[:supplies].find { |s| s.supplier.distillate_fuel_oil_supplier? }
                usage = supply.monthly_overall_trade / 3.96  # $ / ($/gal) = gal
                usage / 0.264  # in L
              end
            end
            quorum 'from MECS energy ratios', :needs => [:mecs_energy, :monthly_fuel_payments] do |characteristics|
              ratio = characteristics[:mecs_energy].fuel_ratios[:distillate_fuel_oil]
              characteristics[:monthly_fuel_payments] * ratio
            end
          end


          committee :electricity_emission_factor do # returns kg CO2 / kWh
            quorum 'from egrid subregion', :needs => :egrid_subregion do |characteristics|
              characteristics[:egrid_subregion].electricity_emission_factor
            end

            quorum 'default' do
              EgridSubregion.fallback.electricity_emission_factor
            end
          end

          committee :electricity_loss_rate do # returns percentage
            quorum 'from egrid region', :needs => :egrid_region do |characteristics|
              characteristics[:egrid_region].loss_factor
            end

            quorum 'default' do
              EgridRegion.fallback.loss_factor
            end
          end
          
          committee :electricity_emission_factor do # returns kg CO2 / kWh
            quorum 'from eGRID subregion', :needs => :egrid_subregion do |characteristics|
              characteristics[:egrid_subregion].electricity_emission_factor
            end
          end
          
          committee :egrid_region do
            quorum 'from eGRID subregion', :needs => :egrid_subregion do |characteristics|
              characteristics[:egrid_subregion].egrid_region
            end

            quorum 'from default' do
              EgridSubregion.fallback
            end
          end
          
          committee :egrid_subregion do
            quorum 'from zip code', :needs => :zip_code do |characteristics|
              characteristics[:zip_code].egrid_subregion
            end
          end
        end
      end
    end
  end
end
