module ApplicationHelper
  def pretty_json(text)
    JSON.pretty_generate(JSON.parse(text))
  end
end
