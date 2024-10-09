module Workflows
  class Stage < ApplicationRecord
    belongs_to :template, class_name: "Workflows::Template"
    validates :name, presence: true
    validates :default_deadline, presence: true
    validates :colour, presence: true
    has_rich_text :description
    has_rich_text :assignment_instructions
    acts_as_list scope: :template
    enum :status, active: 0, inactive: -1
    enum :stage_type, initial: 0, in_progress: 1, review: 10, completed: 100, cancelled: -1
    enum :deadline_type, days_after: 0, days_before: -1
    enum :completion_type, completed_by_any: 0, completed_by_all: 1
    belongs_to :form_template, polymorphic: true, optional: true
    has_many :default_assignments, class_name: "Workflows::DefaultAssignment", dependent: :destroy_async
    has_many :options, class_name: "Workflows::Option", dependent: :destroy_async

    def default_assigned_users = default_assignments.map(&:user)
  end
end
