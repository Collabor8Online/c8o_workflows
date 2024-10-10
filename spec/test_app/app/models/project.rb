class Project < ApplicationRecord
  include Workflows::TemplateContainer
  validates :name, presence: true
  has_many :folders, dependent: :destroy
end
