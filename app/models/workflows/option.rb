module Workflows
  class Option < ApplicationRecord
    include Automations::Container
    belongs_to :stage, class_name: "Workflows::Stage"
    belongs_to :destination_stage, class_name: "Workflows::Stage", optional: true
    has_rich_text :description
  end
end
