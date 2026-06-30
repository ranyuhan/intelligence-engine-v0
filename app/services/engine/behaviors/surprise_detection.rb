# frozen_string_literal: true

module Engine
  module Behaviors
    class SurpriseDetection
      def call(**)
        raise NotImplementedError
      end
    end
  end
end
