# frozen_string_literal: true

module UUIDAble
  extend ActiveSupport::Concern

  included do
    before_validation :assign_uuid, on: :create, unless: :uuid?
    validates :uuid, presence: true, uniqueness: true
  end

  def to_param
    uuid
  end

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
