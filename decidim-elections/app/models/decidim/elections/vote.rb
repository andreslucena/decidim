# frozen_string_literal: true

module Decidim
  module Elections
    # TODO
    class Vote < ApplicationRecord
      PENDING_STATUS = "pending"

      belongs_to :election, foreign_key: "decidim_elections_election_id", class_name: "Decidim::Elections::Election"
    end
  end
end
