# frozen_string_literal: true

module Engine
  module Policies
    class RecommendationPolicy
      def allowed?(**)
        raise NotImplementedError
      end
    end
  end
end
