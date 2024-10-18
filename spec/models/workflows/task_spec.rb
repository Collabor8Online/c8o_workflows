require "rails_helper"

module Workflows
  RSpec.describe Task, type: :model do
    subject(:task) { Workflows::Task.new(container: folder, template: template, name: "Something") }
    let(:folder) { Folder.create! name: "Folder", project: project }
    let(:project) { Project.create! name: "Project" }
    let(:category) { Workflows::Category.create! name: "Category", container: project }
    let!(:alice) { User.create! name: "Alice", email: "alice@example.com" }
    let(:template) { Workflows::Template.create! name: "Template", category: category, default_owner: alice, default_deadline: 2 }

    describe "#name" do
      it "defaults to the name from the template" do
        task.name = ""

        expect(task).to be_valid
        expect(task.name).to eq template.name
      end
    end

    describe "#due_on" do
      it "is required" do
        task.due_on = nil

        expect(task).to_not be_valid
        expect(task.errors).to include :due_on
      end

      it "defaults to 7 days from now" do
        expect(task.due_on).to be_within(1.second).of 7.days.from_now
      end
    end

    describe "#container" do
      it "is required" do
        task.container = nil

        expect(task).to_not be_valid
        expect(task.errors).to include :container
      end

      it "must be a TaskContainer" do
        task.container = alice

        expect(task).to_not be_valid
        expect(task.errors).to include :container
      end
    end
  end
end
