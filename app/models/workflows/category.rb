module Workflows
  class Category < ApplicationRecord
    belongs_to :container, polymorphic: true
    validates :name, presence: true
    validates :name, uniqueness: {scope: [:container, :status]}, if: :active?
    enum :status, active: 0, inactive: -1
    has_many :_templates, class_name: "Workflows::Template", dependent: :destroy_async
    has_many :templates, -> { active.order(:position) }, class_name: "Workflows::Template"
    has_rich_text :description
  end
end
