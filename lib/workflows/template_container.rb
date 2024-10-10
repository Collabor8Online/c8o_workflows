module Workflows
  module TemplateContainer
    extend ActiveSupport::Concern

    included do
      has_many :_workflow_categories, as: :container, class_name: "Workflows::Category", dependent: :destroy_async
      has_many :workflow_categories, -> { active.order :name }, as: :container, class_name: "Workflows::Category"
      has_many :workflow_templates, -> { order :position }, through: :workflow_categories, source: :templates
    end

    def create_workflow_category name:, description: ""
      _workflow_categories.create!(name: name, description: description).tap do |category|
        Workflows.events.notify "workflows/category_created", category: category
      end
    end

    def deactivate_workflow_category category
      category.inactive!
      Workflows.events.notify "workflows/category_deactivated", category: category
    end

    def reactivate_workflow_category category
      category.active!
      Workflows.events.notify "workflows/category_reactivated", category: category
    end
  end
end
