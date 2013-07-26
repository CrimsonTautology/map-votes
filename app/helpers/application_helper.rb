module ApplicationHelper

  def full_title(page_title)
    base = "Map Votes"

    if page_title.empty?
      base
    else
      "#{base} | #{page_title}"
    end

  end

  def smart_map_image_url name
    url = "http://image.www.gametracker.com/images/maps/160x120/tf2/#{name}.jpg"
    if url_responsive? url
      url
    else
      "unkown_image.jpg"
    end
  end

  def url_responsive? url
    uri = URI(url)
    uri_request = Net::HTTP.new uri.host
    uri_response= uri_request.request_head uri.path
    uri_response.code.to_i == 200
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def no_whitespace
    /^[\S]+$/
  end

end
