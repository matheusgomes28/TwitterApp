require 'sqlite3'

# Check if the username given is a
# valid username.
def is_valid_username(username)

  # Open the database
  db = SQLite3::Database.new 'login.db'

  # if value is returned then username is not valid
  if db.execute("SELECT 1 FROM users WHERE username='#{username}'").length > 0 then
    return false
  else
    return true
  end

end

# Check if the email is already
# registered on the system by
# doing a simple query to return
# records with an email.
def is_email_taken(email)

  # Open the database
  db = SQLite3::Database.new 'login.db'

  # Return true if email is not on database
  if db.execute("SELECT 1 FROM users WHERE email='#{email}'").length  > 0 then
    return true
  else
    return false
  end
end
