# Workflows
Collabor8Online Workflows

(watch out - this is licensed under the [LGPL](/LICENCE) which may or may not be suitable for your needs - contact support@collabor8online to discuss options)

## Concepts

Workflows are split into two parts.

There are [Templates](/app/models/workflows/template.rb) and [Tasks](/)

The template defines the process that an individual task will follow as it moves through various stages.

### Templates

Templates are grouped into [Categories](/app/models/workflows/category.rb) which in turn are managed by [Template Containers](/lib/workflows/template_container.rb).

The template container is any ActiveRecord model within your application that holds workflow templates - for example, in Collabor8Online, workflows are organised into Projects.  Include the `Workflows::TemplateContainer` module into your model and this gives you access to the `workflow_categories` and `workflow_templates` associated with that container.

#### Structure

A template is broken into stages.

There is always an initial stage, then there are zero or more in_progress stages, followed by at least one completed and at least one cancelled stage.

Each stage then has one or more options.  Each option defines an action that the end-user can take, and once selected, it moves the task to the next stage, optionally triggering [automations](https://github.com/Collabor8Online/c8o_automations).

#### Building a template from a YAML file

Templates can be configured from [YAML files](/spec/examples/approvals.yml).  To create a template, ensure that your container has a Category with the name specified within the YAML, then use a template builder:

```ruby
@category = @my_container.workflow_categories.create! name: "My category"
@template = Workflows::Template::Builder.new.call(configuration: @my_yaml, container: @my_container)
```

## Usage

For [examples](/spec/examples) check the spec/examples folder.

### Loading a workflow configuration from a YAML file

### Saving a workflow configuration to a YAML file

### [Approving documents](/spec/examples/approving_documents_spec.rb)

### Performing a Quality Control check

### Completing a Health and Safety Inspection


## Installation
Add this line to your application's Gemfile:

```ruby
gem "workflows"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install workflows
```

