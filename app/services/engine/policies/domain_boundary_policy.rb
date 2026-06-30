# frozen_string_literal: true

module Engine
  module Policies
    class DomainBoundaryPolicy
      FORBIDDEN_TERMS = %w[investing stock stocks company companies market markets fundraising healthcare lp gp].freeze

      def allowed?(name:)
        FORBIDDEN_TERMS.none? { |term| name.to_s.downcase.include?(term) }
      end
    end
  end
end
