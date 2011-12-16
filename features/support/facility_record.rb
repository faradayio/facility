require 'active_record'
require 'facility'
require 'sniff'

class FacilityRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::Facility
  set_table_name 'facility_records'
end
