# frozen_string_literal: true

module Engine
  module Pipeline
    class EvaluatePredictions
      def call(prediction:, feedback:)
        raise NotImplementedError
      end
    end
  end
end
