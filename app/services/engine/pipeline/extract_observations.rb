# frozen_string_literal: true

module Engine
  module Pipeline
    class ExtractObservations
      def call(event:)
        raise NotImplementedError, "Implement observation extraction for event #{event.id}"
      end
    end
  end
end
