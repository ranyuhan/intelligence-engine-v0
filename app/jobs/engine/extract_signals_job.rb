# frozen_string_literal: true

module Engine
  class ExtractSignalsJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # TODO: call corresponding Engine::Pipeline service.
      raise NotImplementedError
    end
  end
end
