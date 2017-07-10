require 'rake'
require 'test_helper'

class RakeTaskNameTest < Minitest::Test
  def setup
    Rake.application.in_namespace 'db' do
      Rake::Task.define_task(:drop)
      Rake::Task.define_task(:create)
      Rake::Task.define_task(:migrate)
    end
  end

  def teardown
    Rake::Task.clear
  end

  def test_corrections_include_instance_method
    error = assert_raises(RuntimeError) do
      Rake::Task['db:mirgate']
    end

    assert_match "Did you mean?  db:migrate", error.to_s
  end
end
