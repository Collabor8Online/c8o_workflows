module Workflows
  module TaskContainer
    extend ActiveSupport::Concern

    included do
      has_many :workflow_tasks, -> { not_deleted }, class_name: "Workflows::Task", as: :container
      has_many :_workflow_tasks, class_name: "Workflows::Task", as: :container, dependent: :destroy_async
    end

    def start_workflow(...)
    end
  end
end
