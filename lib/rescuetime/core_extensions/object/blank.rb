module Rescuetime::CoreExtensions
  module Object
    # Includes methods that check the presence or blankness of an object.
    # @since v0.4.0
    module Blank
      # Returns true if the associated object is empty or falsey. Based on
      # Rails' ActiveSupport method Object#blank?
      #
      # @example
      #   module Rescuetime
      #     # ...
      #
      #     def format(report)
      #       # Guard: report presence
      #       report.extend CoreExtensions::Object::Blank
      #       report.blank? && return false
      #       # ...
      #     end
      #   end
      #
      # @return [Boolean]  true if the object is empty or falsey
      # @see #present?
      def blank?
        respond_to?(:empty?) ? !!empty? : !self
      end

      # Returns true if an object is truthy and is not empty (is not blank).
      # Based on Rails' ActiveSupport method Object#present?
      #
      # @example
      #   module Rescuetime
      #     # ...
      #
      #     def api_key?
      #       api_key.extend CoreExtensions::Object::Blank
      #       api_key.present?
      #     end
      #   end
      #
      # @return [Boolean]  true if the object is not blank
      # @see #blank?
      def present?
        !blank?
      end
    end
  end
end
