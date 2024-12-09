class AcknowledgedUser < ApplicationRecord
    has_many :acknowledgments, dependent: :destroy
end
