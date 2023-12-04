json.id @user.id
json.registration_status @user.persisted? ? 'success' : 'failed'
json.confirmation_email_sent @user.confirmation_sent_at.present? ? 'sent' : 'not sent'
