# Configuration basic params
class Configuration
  attr_accessor :access_url, :username, :password

  def initialize
    @access_url = nil
    @username = nil
    @password = nil
  end
end
