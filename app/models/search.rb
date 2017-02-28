class Search < ActiveRecord::Base

  SEARCH_OPTIONS = %w(Questions Answers Comments Users All)

  def self.perform(query, contexts)
    return nil if query.try(:blank?) || !SEARCH_OPTIONS.include?(contexts)
    query = ThinkingSphinx::Query.escape(query)
    if contexts == 'All'
      ThinkingSphinx.search query
    else
      ThinkingSphinx.search(query, classes: [contexts.singularize.classify.constantize])
    end
  end
end
