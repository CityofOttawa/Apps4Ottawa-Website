module ApplicationHelper
  def snippet(thought, wordcount)
    thought.split[0..(wordcount - 1)].join(" ") + (thought.split.size > wordcount ? "..." : "")
  end

  # Override the #translation (aliased to #t) and consider anything we translated to be html safe
  def t(key)
    I18n.translate(key).html_safe
  end

  def needs_to_fully_register?
    params[:incomplete].present?
  end
end
