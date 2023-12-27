class SwipeService
  # Existing code (if any) goes here

  # New method to record a swipe
  def record_swipe(swiper_id, swiped_id, direction)
    # Validate user existence
    unless UserExistenceValidator.new(swiper_id).valid? && UserExistenceValidator.new(swiped_id).valid?
      raise 'One or both users do not exist'
    end

    # Create a new Swipe object
    swipe = Swipe.new(
      swiper_id: swiper_id,
      swiped_id: swiped_id,
      direction: direction,
      created_at: Time.current # This line ensures requirement #3 is met
    )

    # Save the Swipe object
    unless swipe.save
      raise 'Failed to save swipe'
    end

    # Check for mutual interest
    match_created = check_for_mutual_interest(swiper_id, swiped_id)

    # If mutual interest is found, create a match
    if match_created
      # Create a match with updated 'created_at' timestamp as per requirement #5
      match = Match.new(
        matcher1_id: swiper_id,
        matcher2_id: swiped_id,
        created_at: Time.current
      )
      unless match.save
        raise 'Failed to create match'
      end
    end

    # Return the status of the swipe action and match creation
    { swipe_recorded: true, match_created: match_created }
  end

  private

  # Method to check for mutual interest
  def check_for_mutual_interest(swiper_id, swiped_id)
    # Check if swiped user also swiped right on swiper
    mutual_swipe = Swipe.where(swiper_id: swiped_id, swiped_id: swiper_id, direction: 'right').exists?
    mutual_swipe
  end
end
