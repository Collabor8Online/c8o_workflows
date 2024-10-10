require "rails_helper"

RSpec.describe Workflows::TemplateContainer do
  subject(:container) { Project.create! name: "My project" }

  describe "#workflow_categories" do
    it "lists categories within this container" do
      @first = Workflows::Category.create! name: "First", container: container
      @second = Workflows::Category.create! name: "Second", container: container

      expect(container.workflow_categories).to eq [@first, @second]
    end

    it "does not list inactive categories" do
      Workflows::Category.create! name: "Inactive", container: container, status: "inactive"

      expect(container.workflow_categories).to be_empty
    end
  end

  describe "#create_workflow_category" do
    it "creates a new category" do
      @category = container.create_workflow_category name: "Document management", description: "Managing documents"

      expect(@category).to be_persisted
      expect(@category.name).to eq "Document management"
      expect(@category.description.to_plain_text).to eq "Managing documents"
      expect(@category.container).to eq container
    end

    it "publishes a 'workflows/category_created' event" do
      @event = nil
      @data = nil
      Workflows.events.add_observer do |event, data|
        @event = event
        @data = data[:category]
      end
      @category = container.create_workflow_category name: "Document management"

      expect { @event }.to become "workflows/category_created"
      expect(@data).to eq @category
    end
  end

  describe "#deactivate_workflow_category" do
    it "marks the category as inactive" do
      @first = Workflows::Category.create! name: "First", container: container
      @second = Workflows::Category.create! name: "Second", container: container

      container.deactivate_workflow_category @first

      expect(container.workflow_categories).to eq [@second]
      expect(@first.reload).to be_inactive
    end

    it "publishes a 'workflows/category_deactivated' event" do
      @event = nil
      @data = nil
      Workflows.events.add_observer do |event, data|
        @event = event
        @data = data[:category]
      end
      @category = Workflows::Category.create! name: "Category", container: container

      container.deactivate_workflow_category @category

      expect { @event }.to become "workflows/category_deactivated"
      expect(@data).to eq @category
    end
  end

  describe "#reactivate_workflow_category" do
    it "marks the inactive category as active" do
      @category = Workflows::Category.create! name: "Category", container: container, status: "inactive"

      container.reactivate_workflow_category @category

      expect(container.workflow_categories).to eq [@category]
      expect(@category.reload).to be_active
    end

    it "publishes a 'workflows/category_reactivated' event" do
      @event = nil
      @data = nil
      Workflows.events.add_observer do |event, data|
        @event = event
        @data = data[:category]
      end
      @category = Workflows::Category.create! name: "Category", container: container, status: "inactive"

      container.reactivate_workflow_category @category

      expect { @event }.to become "workflows/category_reactivated"
      expect(@data).to eq @category
    end
  end

  describe "#workflow_templates" do
    let(:bob) { User.create! name: "Bob", email: "bob@example.com" }
    it "lists active templates for active categories" do
      @category = Workflows::Category.create! name: "Category", container: container
      @template = Workflows::Template.create! name: "Template", category: @category, default_owner: bob

      expect(container.workflow_templates).to eq [@template]
    end

    it "does not list inactive templates" do
      @category = Workflows::Category.create! name: "Category", container: container
      @template = Workflows::Template.create! name: "Template", category: @category, default_owner: bob, status: "inactive"

      expect(container.workflow_templates).to be_empty
    end

    it "does not list templates for inactive categories" do
      @category = Workflows::Category.create! name: "Category", container: container, status: "inactive"
      @template = Workflows::Template.create! name: "Template", category: @category, default_owner: bob

      expect(container.workflow_templates).to be_empty
    end
  end
end
