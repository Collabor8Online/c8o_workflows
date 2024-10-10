class Document < ApplicationRecord
  belongs_to :folder
  validates :name, presence: true
  has_and_belongs_to_many :reviews
end
