module Workflows
  def self.events = @events
  @events = Plumbing::Pipe.start
end
