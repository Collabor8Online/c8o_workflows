module Workflows
  class Template < ApplicationRecord
    belongs_to :category, class_name: "Workflows::Category"
    belongs_to :default_owner, polymorphic: true
    validates :name, presence: true
    enum :status, active: 0, inactive: -1
    has_rich_text :description
    acts_as_list scope: :category
    has_many :_stages, class_name: "Workflows::Stage", dependent: :destroy_async
    has_one :initial_stage, -> { active.initial }, class_name: "Workflows::Stage"
    has_many :in_progress_stages, -> { active.in_progress.order(:position) }, class_name: "Workflows::Stage"
    has_one :review_stage, -> { active.review }, class_name: "Workflows::Stage"
    has_many :completed_stages, -> { active.completed.order(:position) }, class_name: "Workflows::Stage"
    has_many :cancelled_stages, -> { active.cancelled.order(:position) }, class_name: "Workflows::Stage"
  end
end
