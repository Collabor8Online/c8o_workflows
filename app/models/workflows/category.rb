module Workflows
  class Category < ApplicationRecord
    belongs_to :container, polymorphic: true
    validates :name, presence: true
    validates :name, uniqueness: {scope: [:container, :status]}, if: :active?
    enum :status, active: 0, inactive: -1
    has_many :_templates, class_name: "Workflows::Template", dependent: :destroy_async
    has_many :templates, -> { active.order(:position) }, class_name: "Workflows::Template"
    has_rich_text :description

    def create_template name:, default_owner:
      templates.create!(name: name, default_owner: default_owner).tap do |template|
        Workflows.events.notify "workflows/template_created", template: template
      end
    end

    def deactivate_template template
      template.inactive!
      Workflows.events.notify "workflows/template_deactivated", template: template
    end

    def reactivate_template template
      template.active!
      Workflows.events.notify "workflows/template_reactivated", template: template
    end
  end
end
