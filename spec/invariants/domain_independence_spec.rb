# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Domain independence", type: :model do
  FORBIDDEN_DOMAIN_TERMS = %w[
    company
    stock
    market
    LP
    GP
    fund
    healthcare
  ].freeze

  it "keeps engine model files free of forbidden domain terms" do
    files = Rails.root.glob("app/models/engine/**/*.rb")
    violations = []

    files.each do |file|
      contents = file.read

      FORBIDDEN_DOMAIN_TERMS.each do |term|
        pattern = /\b#{Regexp.escape(term)}\b/i
        next unless contents.match?(pattern)

        violations << "#{file.relative_path_from(Rails.root)} contains #{term.inspect}"
      end
    end

    expect(violations).to be_empty, violations.join("\n")
  end
end
