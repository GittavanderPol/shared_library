module ApplicationHelper
  def connections_to_accept?
    @request_count >= 1
  end

  def request_count
    @request_count
  end
end
