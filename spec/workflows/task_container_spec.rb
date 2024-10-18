require "rails_helper"

RSpec.describe Workflows::TaskContainer do
  subject(:container) { Folder.create! name: "Folder that contains tasks", project: project }
  let(:project) { Project.create! name: "My project" }
  let(:category) { Workflows::Category.create! name: "Document management", container: project }
  let(:template) { Workflows::Template::Builder.new.call category: category, configuration: configuration }
  let(:configuration) { File.read(File.join(__dir__, "..", "examples", "approvals.yml")) }
  let!(:alice) { User.create! name: "Alice", email: "alice@example.com" }
  let!(:bob) { User.create! name: "Bob", email: "bob@example.com" }
  let!(:chris) { User.create! name: "Chris", email: "chris@example.com" }

  before { Workflows.configuration.find_user_by { |email| User.find_by! email: email } }

  describe "#workflow_tasks" do
    it "lists workflow tasks" do
      first_task = Workflows::Task.create! template: template, container: container
      second_task = Workflows::Task.create! template: template, container: container

      expect(container.workflow_tasks.size).to eq 2
      expect(container.workflow_tasks).to include first_task
      expect(container.workflow_tasks).to include second_task
    end

    it "does not list deleted workflow tasks" do
      Workflows::Task.create! template: template, container: container, status: "deleted"

      expect(container.workflow_tasks.size).to eq 0
    end
  end

  describe "#start_workflow_task" do
    it "starts a task using the given template and moves it to the initial stage"
    it "overrides the defaults from the template"
    it "attaches the given items"
    it "publishes a 'wprkflows/task_started' event"
  end

  describe "#cancal_workflow_task" do
    it "cancels the task"
    it "publishes a 'workflows/task_cancelled'"
  end
end
