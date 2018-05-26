class Presence < ApplicationRecord
  belongs_to :class_session
  belongs_to :student
end
