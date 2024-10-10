module Workflows
  class Configuration
    include Plumbing::Actor

    async :find_user_by, :find_user

    def find_user_by &finder
      @find_user = finder
    end

    attr_reader :find_user
  end

  def self.configuration = @configuration

  @configuration = Configuration.start
end
