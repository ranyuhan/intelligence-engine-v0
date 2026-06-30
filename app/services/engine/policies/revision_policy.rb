# frozen_string_literal: true

module Engine
  module Policies
    class RevisionPolicy
      def allowed?(**)
        raise NotImplementedError
      end
    end
  end
end
