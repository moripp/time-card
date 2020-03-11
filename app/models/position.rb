class Position < ApplicationRecord
  # association
  belongs_to :user

  enum authority: {general: 0, admin: 1}

end
