module Workflows
  module TemplateContainer
    extend ActiveSupport::Concern

    included do
      has_many :_workflow_categories, as: :container, class_name: "Workflows::Category", dependent: :destroy_async
      has_many :workflow_categories, -> { active.order(:name) }, as: :container, class_name: "Workflows::Category"
    end
  end
end
