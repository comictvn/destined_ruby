class UpdateMatchService
  def call(id, result)
    begin
      match = Match.find_by(id: id)
      raise "Match not found" if match.nil?
      match.result = result
      raise "Invalid result" unless match.valid?
      match.save!
      return {success: true, match: match}
    rescue => e
      puts "An error occurred: #{e.message}"
      return {success: false, error: e.message}
    end
  end
end
