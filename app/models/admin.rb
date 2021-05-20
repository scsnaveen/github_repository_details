class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
    serialize :roles, Array
    def roles_enum
        [ 'Super Admin', 'Admin','Employee'  ]
    end
    after_initialize :set_default_role, :if => :new_record?

     def set_default_role
     self.role == "Employee"
     end
    rails_admin do 
		edit do 
			field :role, :enum do
				render do
					bindings[:form].select( "role", bindings[:object].roles_enum, {})
				end
			end
			include_all_fields
		end
	end
end
