module Workflows
  class Task < ApplicationRecord
    belongs_to :template, class_name: "Workflows::Template"
    belongs_to :container, polymorphic: true
    validate :container_must_be_a_task_container

    attribute :name, :string
    validates :name, presence: true

    attribute :due_on, :datetime, default: -> { 7.days.from_now }
    validates :due_on, presence: true

    enum :status, started: 0, completed: 100, cancelled: -1, deleted: -100

    before_validation do
      self.name = template.name if name.blank?
    end

    def container_must_be_a_task_container
      errors.add(:container, :invalid) unless container.is_a?(TaskContainer)
    end
  end
end
