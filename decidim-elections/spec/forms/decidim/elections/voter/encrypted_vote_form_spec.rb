# frozen_string_literal: true

require "spec_helper"

describe Decidim::Elections::Voter::EncryptedVoteForm do
  subject { described_class.from_params(params).with_context(context) }
  let(:params) do
    {
      encrypted_vote: { question_1: "aNsWeR 1" }
    }
  end
  let(:context) do
    {
      user: create(:user),
      election: create(:election)
    }
  end

  context "when everything is fine" do
    it { is_expected.to be_valid }
  end

  context "when the encrypted vote is not present" do
    let(:params) { {} }
    it { is_expected.to be_invalid }
  end

  context "when the user is not present" do
    let(:context) do
      { 
        election: create(:election)
      }
    end

    it { is_expected.to be_invalid }
  end

  context "when the election is not present" do
    let(:context) do
      { 
        user: create(:user)
      }
    end

    it { is_expected.to be_invalid }
  end
end