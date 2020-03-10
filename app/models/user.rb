class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  # association
  has_many :attendances
  has_one :status

  # validations
  validates :name, presence: true
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,}+\z/i} # 次の3条件全て満たす場合許可する  8文字以上、半角英数字のみで入力、英字と数字を1文字以上含む
end