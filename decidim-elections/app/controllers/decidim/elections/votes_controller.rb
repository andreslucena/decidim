# frozen_string_literal: true

module Decidim
  module Elections
    # Exposes the elections resources so users can participate on them
    class VotesController < Decidim::Elections::ApplicationController
      layout "decidim/election_votes"
      include FormFactory

      helper VotesHelper
      helper_method :elections, :election, :questions, :questions_count, :booth_mode

      skip_before_action :verify_authenticity_token, only: :cast # TODO: do something

      delegate :count, to: :questions, prefix: true

      def new
        redirect_to(return_path, alert: t("votes.messages.not_allowed", scope: "decidim.elections")) unless booth_mode
      end

      def cast
        form = Voter::EncryptedVoteForm.from_params(params).with_context(user: current_user)
        Voter::CastVote.call(form) do
          on(:ok) do
            render json: { ok: true }
          end
          on(:invalid) do
            render json: { ok: false }
          end
        end
      end

      private

      def booth_mode
        @booth_mode ||= if allowed_to? :vote, :election, election: election
                          :vote
                        elsif allowed_to? :preview, :election, election: election
                          :preview
                        end
      end

      def return_path
        @return_path ||= if allowed_to? :view, :election, election: election
                           election_path(election)
                         else
                           elections_path
                         end
      end

      def elections
        @elections ||= Election.where(component: current_component)
      end

      def election
        @election ||= elections.find(params[:election_id])
      end

      def questions
        @questions ||= election.questions.includes(:answers).order(weight: :asc, id: :asc)
      end
    end
  end
end
