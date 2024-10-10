class Folder < ApplicationRecord
  belongs_to :project
  validates :name, presence: true
  has_many :documents, dependent: :destroy
end
