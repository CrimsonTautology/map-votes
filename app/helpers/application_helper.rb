module ApplicationHelper

  def full_title(page_title)
    base = "Map Votes"

    if page_title.empty?
      base
    else
      "#{base} | #{page_title}"
    end

  end

  def url_responsive? url
    begin
      uri = URI(url)
      uri_request = Net::HTTP.new uri.host
      uri_response= uri_request.request_head uri.path
      uri_response.code.to_i == 200
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end
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

end
