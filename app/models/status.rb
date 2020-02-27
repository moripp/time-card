class Status < ApplicationRecord
  # association
  belongs_to :user

  enum state: {leave_work: 0, going_to_work: 1}

end
