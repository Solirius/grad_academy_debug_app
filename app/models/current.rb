# Current provides thread-local attributes that can be accessed globally within
# the application.
#
# It inherits from ActiveSupport::CurrentAttributes, allowing attributes to be
# defined and accessed at runtime, scoped to the current thread.
#
# Example Usage:
#   Current.user = User.find(session[:user_id])
#
#   # Accessing the current user from anywhere in the application
#   user = Current.user
#
# Attributes:
#   - user: Stores the currently authenticated user object.
#
# Note: CurrentAttributes provides a convenient way to manage state that is
#       accessible across different parts of the application within the same
#       thread context.
#
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
