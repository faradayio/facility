module BrighterPlanet
  module Facility
    module Data
      def self.included(base)
        base.col :TODO, :type => :TODO
        
        base.data_miner do
          process "TODO" do
            // TODO
          end
        end
      end
    end
  end
end
