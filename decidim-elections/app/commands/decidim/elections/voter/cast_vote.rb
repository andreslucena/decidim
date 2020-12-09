# frozen_string_literal: true

module Decidim
  module Elections
    module Voter
      # TODO
      class CastVote < Rectify::Command
        # TODO
        def initialize(form, bulletin_board_client: Decidim::Elections.bulletin_board)
          @form = form
          @bulletin_board_client = bulletin_board_client
        end

        # TODO
        def call
          return broadcast(:invalid) unless form.valid?

          begin
            store_vote
            cast_vote_on_bulletin_board
            broadcast(:ok)
          rescue # TODO: rescue a valid exception
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form, :bulletin_board_client

        def cast_vote_on_bulletin_board
          bulletin_board_client.cast_vote(election_data, voter_data, encrypted_vote)
        end

        def store_vote
          Vote.create!(
            election: form.election,
            voter_id: voter_id,
            encrypted_vote_hash: encrypted_vote_hash,
            status: Vote::PENDING_STATUS
          )
        end

        def election_data
          @election_data ||= { election_id: "test.1" }
        end
        
        def voter_data
          @voter_data ||= { voter_id: voter_id }
        end

        def voter_id
          @voter_id ||= "voter.1"
        end

        def encrypted_vote
          @encrypted_vote ||= form.encrypted_vote
        end

        def encrypted_vote_hash
          @encrypted_vote_hash ||= "1234"
        end
      end
    end
  end
end
