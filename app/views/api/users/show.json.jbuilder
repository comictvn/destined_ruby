
if @message.present?

  json.message @message

else

  json.user do
    json.id @user.id

    json.name @user.name if @user.name.present?
    json.bio @user.bio if @user.bio.present?

    json.created_at @user.created_at

    json.updated_at @user.updated_at

    json.phone_number @user.phone_number

    json.thumbnail @user.thumbnail

    json.firstname @user.firstname

    json.lastname @user.lastname

    json.dob @user.dob

    json.gender @user.gender

    json.interests @user.interests

    json.location @user.location

    json.matcher2_matchs @user.matcher2_matchs do |matcher2_match|
      json.id matcher2_match.id

      json.created_at matcher2_match.created_at

      json.updated_at matcher2_match.updated_at

      json.matcher1_id matcher2_match.matcher1_id

      json.matcher2_id matcher2_match.matcher2_id
    end

    json.sender_messages @user.sender_messages do |sender_message|
      json.id sender_message.id

      json.created_at sender_message.created_at

      json.updated_at sender_message.updated_at

      json.sender_id sender_message.sender_id
    end

    json.user_chanels @user.user_chanels do |user_chanel|
      json.id user_chanel.id

      json.created_at user_chanel.created_at

      json.updated_at user_chanel.updated_at

      json.user_id user_chanel.user_id
    end

    json.matcher1_matchs @user.matcher1_matchs do |matcher1_match|
      json.id matcher1_match.id

      json.created_at matcher1_match.created_at

      json.updated_at matcher1_match.updated_at

      json.matcher1_id matcher1_match.matcher1_id
    end

    json.email @user.email

    json.reacter_reactions @user.reacter_reactions do |reacter_reaction|
      json.id reacter_reaction.id

      json.created_at reacter_reaction.created_at

      json.updated_at reacter_reaction.updated_at

      json.reacter_id reacter_reaction.reacter_id
    end

    json.reacted_reactions @user.reacted_reactions do |reacted_reaction|
      json.id reacted_reaction.id

      json.created_at reacted_reaction.created_at

      json.updated_at reacted_reaction.updated_at

      json.reacter_id reacted_reaction.reacter_id

      json.reacted_id reacted_reaction.reacted_id
    end
  end

end
