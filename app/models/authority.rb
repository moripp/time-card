class Authority < ApplicationRecord
  # association
  belongs_to :user

  enum auth: {general: 0, admin: 1}

end
