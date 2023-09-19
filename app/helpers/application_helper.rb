module ApplicationHelper
  include Pagy::Frontend

  def connections_to_accept?
    @request_count >= 1
  end

  def request_count
    @request_count
  end

  def order_param(attribute)
    direction = "asc"

    if @order_attribute == attribute.to_s
      if @order_direction == "asc"
        direction = "desc"
      end
    end

    { sort: "#{attribute}_#{direction}" }
  end

  def order_icon(attribute)
    return "" unless @order_attribute == attribute.to_s

    direction = if @order_direction == "asc"
      "up"
    else
      "down"
    end

    "<i class=\"bi bi-caret-#{direction}-fill\"></i>".html_safe
  end
end
