class StoredSession::Configuration
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :base_controller_class_name, :string, default: "::ApplicationController"
  attribute :base_job_class_name, :string, default: "::ApplicationJob"
  attribute :base_record_class_name, :string, default: "::ApplicationRecord"

  attribute :connects_to
  attribute :max_created_age, default: 30.days
  attribute :max_updated_age, default: 30.days

  attribute :sessions_table_name, :string, default: "stored_sessions"
  attribute :session_class_name, :string, default: "::StoredSession::Session"

  attribute :trim_sessions_job_enabled, :boolean, default: true
  attribute :trim_sessions_job_queue_as, default: :default

  validates :base_controller_class_name, presence: true
  validates :base_job_class_name, presence: true
  validates :base_record_class_name, presence: true

  validates :sessions_table_name, presence: true
  validates :session_class_name, presence: true

  validates :max_created_age, numericality: { greater_than: 0 }, presence: true
  validates :max_updated_age, numericality: { greater_than: 0 }, presence: true

  validates :trim_sessions_job_queue_as, presence: true

  def base_controller_class = base_controller_class_name.constantize
  def base_job_class = base_job_class_name.constantize
  def base_record_class = base_record_class_name.constantize
  def session_class = session_class_name.constantize
end
