require "rails_helper"

RSpec.describe Workflows::Template::Builder do
  subject(:builder) { described_class.new }
  let(:configuration) { File.read(File.join(__dir__, "..", "..", "examples", "approvals.yml")) }
  let(:project) { Project.create! name: "My project" }
  let(:category) { Workflows::Category.create! name: "Document management", container: project }

  context "without a category" do
    it "fails" do
      expect { builder.call(configuration: configuration, category: nil) }.to raise_error(Plumbing::PreConditionError)
    end
  end

  context "without a configuration" do
    it "fails" do
      expect { builder.call(configuration: nil, category: category) }.to raise_error(Plumbing::PreConditionError)
    end
  end

  context "when no find_user routine is set" do
    it "fails" do
      expect do
        builder.call(configuration: configuration, category: category)
      end.to raise_error(Plumbing::PreConditionError)
    end
  end

  context "when a find_user routine is set" do
    let!(:bob) { User.create! name: "Bob", email: "bob@example.com" }
    let!(:chris) { User.create! name: "Chris", email: "chris@example.com" }

    before do
      Workflows.configuration.find_user_by do |email|
        User.find_by! email: email
      end
    end

    it "creates a template" do
      template = builder.call(configuration: configuration, category: category)

      expect(template).to_not be_nil
      expect(template.name).to eq "Approval"
      expect(template.description.to_plain_text).to eq "Simple document approval process"
      expect(template.default_owner).to eq bob
      expect(template.default_deadline).to eq 7
    end

    it "creates the initial stage" do
      template = builder.call(configuration: configuration, category: category)
      initial_stage = template.initial_stage
      expect(initial_stage).to_not be_nil
      expect(initial_stage.name).to eq "Awaiting review"
      expect(initial_stage.description.to_plain_text).to eq "These documents are awaiting review"
      expect(initial_stage.assignment_instructions.to_plain_text).to eq "Please prepare these documents for review"
      expect(initial_stage.default_assigned_users).to eq [chris]
      expect(initial_stage.default_deadline).to eq 1
      expect(initial_stage.completion_type).to eq "completed_by_any"
      expect(initial_stage.colour).to eq "#181F1C"
      expect(initial_stage.options.count).to eq 1

      option = initial_stage.options.first
      expect(option.name).to eq "Start review"
      expect(option.description.to_plain_text).to eq "Start the review process"
      expect(option.colour).to eq "#315C2B"
      expect(option.destination_stage).to eq template.stages.find_by!(name: "In review")
      expect(option.automations.count).to eq 1
      automation = option.automations.first
      expect(automation.name).to eq "Start review"
      expect(automation.actions.count).to eq 1
      expect(automation.actions.first.name).to eq "Move to Review folder"
      expect(automation.actions.first.handler).to be_kind_of(MoveDocumentsToFolder)
    end

    it "creates in progress stages" do
      template = builder.call(configuration: configuration, category: category)
      review_stage = template.in_progress_stages.first
      expect(review_stage).to_not be_nil
      expect(review_stage.name).to eq "In review"
      expect(review_stage.description.to_plain_text).to be_blank
      expect(review_stage.assignment_instructions.to_plain_text).to eq "Please review these documents"
      expect(review_stage.default_assigned_users).to eq [bob, chris]
      expect(review_stage.default_deadline).to eq 2
      expect(review_stage.completion_type).to eq "completed_by_all"
      expect(review_stage.colour).to eq "#274029"
      expect(review_stage.options.count).to eq 2

      option = review_stage.options.first
      expect(option.name).to eq "Approve"
      expect(option.description.to_plain_text).to eq "Approve these documents"
      expect(option.colour).to eq "#60712F"
      expect(option.destination_stage).to eq template.stages.find_by!(name: "Approved")
      expect(option.automations.count).to eq 1
      automation = option.automations.first
      expect(automation.name).to eq "Approve documents"
      expect(automation.actions.count).to eq 1
      expect(automation.actions.first.name).to eq "Move to Approved folder"
      expect(automation.actions.first.handler).to be_kind_of(MoveDocumentsToFolder)

      option = review_stage.options.last
      expect(option.name).to eq "Reject"
      expect(option.description.to_plain_text).to eq "Reject these documents"
      expect(option.colour).to eq "#E88873"
      expect(option.destination_stage).to eq template.stages.find_by!(name: "Rejected")
      expect(option.automations.count).to eq 1
      automation = option.automations.first
      expect(automation.name).to eq "Reject documents"
      expect(automation.actions.count).to eq 1
      expect(automation.actions.first.name).to eq "Move to Rejected folder"
      expect(automation.actions.first.handler).to be_kind_of(MoveDocumentsToFolder)
    end

    it "creates completed stages" do
      template = builder.call(configuration: configuration, category: category)
      completed_stage = template.completed_stages.first
      expect(completed_stage).to_not be_nil
      expect(completed_stage.name).to eq "Approved"
      expect(completed_stage.description.to_plain_text).to be_blank
      expect(completed_stage.assignment_instructions.to_plain_text).to be_blank
      expect(completed_stage.default_assigned_users).to eq []
      expect(completed_stage.colour).to eq "#60712F"
      expect(completed_stage.options.count).to eq 0
    end

    it "creates cancelled stages" do
      template = builder.call(configuration: configuration, category: category)
      cancelled_stage = template.cancelled_stages.first
      expect(cancelled_stage).to_not be_nil
      expect(cancelled_stage.name).to eq "Rejected"
      expect(cancelled_stage.description.to_plain_text).to be_blank
      expect(cancelled_stage.assignment_instructions.to_plain_text).to be_blank
      expect(cancelled_stage.default_assigned_users).to eq []
      expect(cancelled_stage.colour).to eq "#E88873"
      expect(cancelled_stage.options.count).to eq 0
    end
  end
end
