require "rails_helper"

RSpec.describe Workflows::Category do
  subject(:category) { Workflows::Category.new name: "My category", container: project }
  let(:project) { Project.create! name: "My project" }
  let(:alice) { User.create! name: "Alice", email: "alice@example.com" }

  describe "#name" do
    it "is required" do
      expect(category).to be_valid

      category.name = ""
      expect(category).to_not be_valid
      expect(category.errors).to include :name
    end

    it "is unique for the container" do
      @existing = Workflows::Category.create! name: "My category", container: project

      expect(category).to_not be_valid
      expect(category.errors).to include :name
    end

    it "is not unique for inactive categories" do
      @existing = Workflows::Category.create! name: "My category", container: project, status: "inactive"

      expect(category).to be_valid
    end
  end

  describe "#container" do
    it "is required" do
      expect(category).to be_valid

      category.container = nil
      expect(category).to_not be_valid
      expect(category.errors).to include :container
    end
  end

  describe "#templates" do
    it "lists active templates" do
      @first = Workflows::Template.create! name: "First", category: category, default_owner: alice
      @second = Workflows::Template.create! name: "Second", category: category, default_owner: alice, status: "inactive"

      expect(category.templates).to include @first
      expect(category.templates).to_not include @second
    end
  end

  describe "#create_template" do
    it "creates a new template from a configuration"
    it "publishes a 'workflows/template_created' event"
  end

  describe "#deactivate_template" do
    it "marks the template as inactive"
    it "publishes a 'workflows/template_deactivated' event"
  end

  describe "#reactivate_template" do
    it "marks the template as inactive"
    it "publishes a 'workflows/template_reactivated' event"
  end
end
