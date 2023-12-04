json.status @user.errors.any? ? 'error' : 'success'
json.message @user.errors.any? ? @user.errors.full_messages : 'Password update was successful'
