# frozen_string_literal: true

module Engine
  module Behaviors
    class ObservableCoverageUpdate
      def call(**)
        raise NotImplementedError
      end
    end
  end
end
