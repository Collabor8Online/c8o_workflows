class Workflows::Template::Builder
  include Plumbing::Pipeline

  pre_condition :must_have_category do |input|
    input[:category].present?
  end

  pre_condition :must_have_configuration do |input|
    input[:configuration].present?
  end

  pre_condition :find_user_by_must_be_configured do |input|
    await { Workflows.configuration.find_user }
  end

  perform :prepare
  perform :create_template

  private

  def prepare input
    find_user = await { Workflows.configuration.find_user }
    {config: YAML.load(input[:configuration]), category: input[:category], find_user: find_user}
  end

  def create_template input
    config = input[:config]
    category = input[:category]
    find_user = input[:find_user]
    template = category.templates.create! name: config["name"], description: config["description"], default_deadline: config["default_deadline"], default_owner: find_user.call(config["default_owner"])
  end
end
