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
      expect(initial_stage.default_assignments).to eq [chris]
      expect(initial_stage.default_deadline).to eq 1
      expect(initial_stage.completion_type).to eq "completed_by_any"
      expect(initial_stage.colour).to eq "#181F1C"
      expect(initial_stage.options.count).to eq 1
    end
  end
end
