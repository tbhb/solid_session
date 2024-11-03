class SolidSession::Configuration
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :base_controller_class_name, :string, default: "::ApplicationController"
  attribute :base_job_class_name, :string, default: "::ApplicationJob"
  attribute :base_record_class_name, :string, default: "::ApplicationRecord"

  validates :base_controller_class_name, presence: true
  validates :base_job_class_name, presence: true
  validates :base_record_class_name, presence: true

  def base_controller_class = base_controller_class_name.constantize
  def base_job_class = base_job_class_name.constantize
  def base_record_class = base_record_class_name.constantize
end
