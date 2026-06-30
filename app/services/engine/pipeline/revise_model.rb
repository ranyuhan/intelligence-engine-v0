# frozen_string_literal: true

module Engine
  module Pipeline
    class ReviseModel
      def call(model:, evidence:)
        raise NotImplementedError
      end
    end
  end
end
