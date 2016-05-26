# frozen_string_literal: true

require 'rescuetime/core_extensions/object/blank'

module Rescuetime::CoreExtensions
  # Represents an exteded Rescuetime::String object
  class String < ::String
    include Object::Blank
  end
end
