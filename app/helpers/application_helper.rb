module ApplicationHelper

  def full_title(page_title)
    base = "Map Votes"

    if page_title.empty?
      base
    else
      "#{base} | #{page_title}"
    end

  end
end
