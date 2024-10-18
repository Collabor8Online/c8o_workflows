class Folder < ApplicationRecord
  include Workflows::TaskContainer
  belongs_to :project
  validates :name, presence: true
  has_many :documents, dependent: :destroy
end
