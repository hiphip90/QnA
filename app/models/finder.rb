class Finder
  SCOPES = ['Questions', 'Answers', 'Comments', 'Users']

  def self.perform_search(q, scope)
    results = {}
    if scope == 'Everywhere'
      SCOPES.each do |scope|
        results[scope] = find_in_scope(q, scope)
      end
    else
      results[scope] = find_in_scope(q, scope)
    end
    results
  end

  private
    def self.find_in_scope(q, scope)
      scope.singularize.constantize.search q
    end
end