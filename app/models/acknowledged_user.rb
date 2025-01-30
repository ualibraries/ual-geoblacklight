# frozen_string_literal: true

class AcknowledgedUser < ApplicationRecord
  has_many :acknowledgments, dependent: :destroy
  validates :netid, presence: true, uniqueness: true
end
