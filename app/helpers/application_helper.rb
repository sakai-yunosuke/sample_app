# frozen_string_literal: true

module ApplicationHelper
  # Return full title string for each page.
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'

    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
