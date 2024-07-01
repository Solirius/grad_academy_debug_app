# ApplicationRecord serves as the primary abstract class for all models in the application.
#
# It inherits from ActiveRecord::Base, providing essential functionality for interacting
# with the database through ActiveRecord ORM.
#
# All models in the application should inherit from ApplicationRecord rather than directly
# from ActiveRecord::Base. This setup allows for centralized configurations, behaviors,
# and extensions to be applied uniformly across all models.
#
# Example Usage:
#   class User < ApplicationRecord
#     validates :email, presence: true, uniqueness: true
#   end
#
#   user = User.new(email: 'user@example.com')
#   user.save
#
# Note: Modify this class as needed to include global settings, methods, or behaviors
#       applicable to all models in your Rails application.
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
