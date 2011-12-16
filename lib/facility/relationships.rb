module BrighterPlanet
  module Facility
    module Relationships
      def self.included(base)
        base.belongs_to :zip_code
        base.has_one :egrid_subregion, :through => :zip_code
        base.belongs_to :industry
        base.has_one :mecs_energy, :foreign_key => :naics_code, :primary_key => :naics_code
      end
    end
  end
end
