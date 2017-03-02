class DbIndexJob < ApplicationJob
  queue_as :default

  def perform
    ThinkingSphinx::Development.index
  end
end
