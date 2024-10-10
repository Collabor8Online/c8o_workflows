require "rails_helper"

RSpec.describe "approving documents" do
  let(:project) { Project.create! name: "Documents" }
  let!(:uploads_folder) { Folder.create! name: "Uploads", project: project }
  let!(:in_review_folder) { Folder.create! name: "In review", project: project }
  let!(:approved_folder) { Folder.create! name: "Approved", project: project }
  let!(:rejected_folder) { Folder.create! name: "Rejected", project: project }

  let!(:alice) { User.create! name: "Alice", email: "alice@example.com", admin: true }
  let!(:bob) { User.create! name: "Bob", email: "bob@example.com", admin: false }
  let!(:chris) { User.create! name: "Chris", email: "chris@example.com", admin: false }
  let!(:dave) { User.create! name: "Dave", email: "dave@example.com", admin: false }

  let(:category) { Workflows::Category.create! name: "Document management", container: project }
  let(:template) { Workflows::Template::Builder.new.call configuration: configuration, container: project }
  let(:configuration) { File.read(File.join(__dir__, "approvals.yml")) }

  before do
    Workflows.configuration.find_user_by do |email|
      User.find_by! email: email
    end
  end

  it "assigns the task with default values"
  #     first_document = Document.create! name: "first.txt", folder: uploads_folder
  #     second_document = Document.create! name: "second.txt", folder: uploads_folder
  #     review = Review.create! documents: [first_document, second_document]
  #
  #     task = review.start_workflow template
  #
  #     expect(task.refers_to).to eq review
  #     expect(review.workflow_tasks).to include(task)
  #
  #     expect(task.title).to eq "Approval"
  #     expect(task.due_on).to eq(Date.today + 7)
  #     expect(task.description.to_plain_text).to eq "Simple document approval process"
  #     expect(task.current_status.name).to eq "Awaiting review"
  #     expect(task.assigned_to).to include(chris)

  it "assigns the task with overridden values"
  #     first_document = Document.create! name: "first.txt", folder: uploads_folder
  #     second_document = Document.create! name: "second.txt", folder: uploads_folder
  #     review = Review.create! documents: [first_document, second_document]
  #
  #     task = review.start_workflow template, title: "Please review", description: "URGENTLY", due_on: Date.tomorrow, assign_to: dave
  #
  #     expect(task.refers_to).to eq review
  #     expect(review.workflow_tasks).to include(task)
  #
  #     expect(task.title).to eq "Please review"
  #     expect(task.due_on).to eq(Date.today + 7)
  #     expect(task.description.to_plain_text).to eq "URGENTLY"
  #     expect(task.current_status.name).to eq "Awaiting review"
  #     expect(task.assigned_to).to include(dave)
end
