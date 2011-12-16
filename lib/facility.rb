require 'emitter'

module BrighterPlanet
  module Facility
    extend BrighterPlanet::Emitter
    # FIXME TODO each impact should have its own scope; this is the scope of the greenhouse gas emission (carbon) impact
    scope 'The Facility greenhouse gas emission is the anthropogenic greenhouse gas emissions attributed to TODO'
  end
end
