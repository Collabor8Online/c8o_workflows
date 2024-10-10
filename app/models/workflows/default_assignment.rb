module Workflows
  class DefaultAssignment < ApplicationRecord
    belongs_to :stage, class_name: "Workflows::Stage"
    belongs_to :user, polymorphic: true
  end
end
