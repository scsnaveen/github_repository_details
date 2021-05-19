class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
					:recoverable, :rememberable, :validatable,
					:confirmable, :lockable, :timeoutable, :trackable

		# validation for first name 
		validates :first_name, presence: true,format: { with: /\A[a-zA-Z]+\z/,message: "must be in alphabets" }
		# validation for last name
		validates :last_name,presence: true,format: { with: /\A[a-zA-Z]+\z/,message: "must be in alphabets " }
		# validation for phone number
		validates :phone_number,numericality: { only_integer: true },presence: true,:length => { :minimum => 10, :maximum => 15 }
end
