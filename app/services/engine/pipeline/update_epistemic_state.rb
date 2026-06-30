# frozen_string_literal: true

module Engine
  module Pipeline
    class UpdateEpistemicState
      def call(model:)
        raise NotImplementedError
      end
    end
  end
end
