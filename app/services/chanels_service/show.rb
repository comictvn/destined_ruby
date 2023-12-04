class ChanelsService
  def self.show(id)
    chanel = Chanel.find_by(id: id)
    if chanel
      return chanel
    else
      return { error: "Chanel not found" }
    end
  end
end
