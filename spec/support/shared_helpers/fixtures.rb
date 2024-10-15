# frozen_string_literal: true

module SharedHelpers::Fixtures
  def json_fixture(filename)
    JSON.parse(file_fixture(filename).read).with_indifferent_access
  end
end
