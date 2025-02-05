# frozen_string_literal: true

class Acknowledgment < ApplicationRecord
  belongs_to :acknowledged_users
end
