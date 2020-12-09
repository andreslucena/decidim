# frozen_string_literal: true

module Decidim
  module Elections
    module Voter
      # TODO
      class EncryptedVoteForm < Decidim::Form
        attribute :encrypted_vote, Hash
        validates :encrypted_vote, :user, :election, presence: true

        def user
          @user ||= context.user
        end

        def election
          @election ||= context.election
        end
      end
    end
  end
end
