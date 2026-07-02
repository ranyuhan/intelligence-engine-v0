# frozen_string_literal: true

module Engine
  module Pipeline
    class ReviseModel
      DEFAULT_CAUSE = "new_evidence"

      def call(model:, evidence:, outcome:, summary:, new_state:, hypothesis: nil, cause: DEFAULT_CAUSE)
        evidence_records = normalize_evidence!(evidence)
        previous_state = model.state.deep_dup
        revision_new_state = outcome == "unchanged" ? previous_state : new_state

        ActiveRecord::Base.transaction do
          revision = Engine::Revision.new(
            model: model,
            cause: cause,
            summary: summary,
            outcome: outcome,
            previous_state: previous_state,
            new_state: revision_new_state,
            confidence_delta: 0,
            metadata: {}
          )

          evidence_records.each do |evidence_record|
            revision.revision_evidences.build(evidence: evidence_record, metadata: {})
          end

          revision.save!

          update_model!(model, outcome: outcome, new_state: revision_new_state, hypothesis: hypothesis)
          update_epistemic_state!(model, revised_at: revision.created_at)

          revision
        end
      end

      private

      def normalize_evidence!(evidence)
        evidence_records = Array.wrap(evidence).flatten.compact
        return evidence_records if evidence_records.any?

        raise ArgumentError, "at least one evidence record is required"
      end

      def update_model!(model, outcome:, new_state:, hypothesis:)
        return if outcome == "unchanged"

        model.state = new_state
        model.version += 1
        model.hypothesis = hypothesis if hypothesis.present?
        model.save!
      end

      def update_epistemic_state!(model, revised_at:)
        return unless model.epistemic_state.present?

        model.epistemic_state.update!(last_revised_at: revised_at)
      end
    end
  end
end
