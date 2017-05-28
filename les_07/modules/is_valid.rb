module IsValid
  def valid?
    validate!
  rescue
    false
  end
end