# frozen_string_literal: true

module Engine
  module Pipeline
    class ExtractSignals
      def call(observation:)
        raise NotImplementedError
      end
    end
  end
end
