class Workflows::Template::Builder
  include Plumbing::Pipeline

  pre_condition :must_have_category do |input|
    input[:category].present?
  end

  pre_condition :must_have_configuration do |input|
    input[:configuration].present?
  end

  pre_condition :find_user_by_must_be_configured do |_input|
    await { Workflows.configuration.find_user }
  end

  perform :prepare
  perform :create_template
  execute :create_initial_stage
  execute :create_in_progress_stages
  execute :create_completed_stages
  execute :create_cancelled_stages
  execute :add_options_to_initial_stage
  execute :add_options_to_in_progress_stages
  perform :finish

  private

  def prepare(input)
    find_user = await { Workflows.configuration.find_user }
    category = input[:category]
    config = YAML.load(input[:configuration], symbolize_names: true)
    {config: config, category: category, find_user: find_user}
  end

  def create_template(input)
    config = input[:config]
    find_user = input[:find_user]
    template = input[:category].templates.create! name: config[:name], description: config[:description],
      default_deadline: config[:default_deadline], default_owner: find_user.call(config[:default_owner])

    input.merge(template: template)
  end

  def create_initial_stage(input)
    config = input[:config][:initial_stage]
    template = input[:template]
    find_user = input[:find_user]

    build_stage(config, "initial", find_user).update! template: template
  end

  def create_in_progress_stages input
    configs = input[:config][:in_progress_stages]
    template = input[:template]
    find_user = input[:find_user]

    configs.each do |config|
      build_stage(config, "in_progress", find_user).update! template: template
    end
  end

  def create_completed_stages input
    configs = input[:config][:completed_stages]
    template = input[:template]
    find_user = input[:find_user]

    configs.each do |config|
      build_stage(config, "completed", find_user).update! template: template
    end
  end

  def create_cancelled_stages input
    configs = input[:config][:cancelled_stages]
    template = input[:template]
    find_user = input[:find_user]

    configs.each do |config|
      build_stage(config, "cancelled", find_user).update! template: template
    end
  end

  def add_options_to_initial_stage input
    configs = input[:config][:initial_stage][:options] || []
    template = input[:template]

    configs.each do |config|
      build_option template, template.initial_stage, config
    end
  end

  def add_options_to_in_progress_stages input
    stage_configs = input[:config][:in_progress_stages]
    template = input[:template]
    stage_configs.each do |stage_config|
      stage = template.stages.find_by! name: stage_config[:name]
      configs = stage_config[:options] || []
      configs.each do |config|
        build_option template, stage, config
      end
    end
  end

  def finish input
    input[:template]
  end

  def build_stage config, stage_type, find_user
    assignment_configs = config[:default_assignments] || []
    default_assignments = assignment_configs.map do |assignment|
      Workflows::DefaultAssignment.new(user: find_user.call(assignment))
    end

    params = config.slice(:name, :description, :assignment_instructions, :default_deadline, :deadline_type, :completion_type, :colour).merge(default_assignments: default_assignments, stage_type: stage_type)

    Workflows::Stage.new params
  end

  def build_option template, stage, config
    destination_stage = template.stages.find_by! name: config[:destination_stage]
    params = config.slice(:name, :description, :colour).merge(stage: stage, destination_stage: destination_stage)
    Workflows::Option.create!(params).tap do |option|
      config[:automations].map do |automation_config|
        Automations::Builder.new(automation_config, container: option).build_automation
      end
      option.reload
    end
  end
end
