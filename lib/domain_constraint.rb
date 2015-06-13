class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.map { |dom| request.domain.ends_with?(dom) }.include? true
  end
end
