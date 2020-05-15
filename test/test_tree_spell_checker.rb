# frozen_string_literal: true

require "yaml"

require_relative "./helper"

class TreeSpellCheckerTest < Test::Unit::TestCase
  MINI_DIRECTORIES = YAML.load_file(File.expand_path("fixtures/mini_dir.yml", __dir__))
  RSPEC_DIRECTORIES = YAML.load_file(File.expand_path("fixtures/rspec_dir.yml", __dir__))

  def setup
    @dictionary =
      %w(
        spec/models/concerns/vixen_spec.rb
        spec/models/concerns/abcd_spec.rb
        spec/models/concerns/vixenus_spec.rb
        spec/models/concerns/efgh_spec.rb
        spec/modals/confirms/abcd_spec.rb
        spec/modals/confirms/efgh_spec.rb
        spec/models/gafafa_spec.rb
        spec/models/gfsga_spec.rb
        spec/controllers/vixen_controller_spec.rb
      )
    @test_str = "spek/modeks/confirns/viken_spec.rb"
    @tree_spell_checker = DidYouMean::TreeSpellChecker.new(dictionary: @dictionary)
  end

  def test_corrupt_root
    word = "test/verbose_formatter_test.rb"
    word_error = "btets/cverbose_formatter_etst.rb suggestions"
    tsp = DidYouMean::TreeSpellChecker.new(dictionary: MINI_DIRECTORIES)
    s = tsp.correct(word_error).first

    assert_match s, word
  end

  def test_leafless_state
    tsp = DidYouMean::TreeSpellChecker.new(dictionary: @dictionary.push("spec/features"))
    word = "spec/modals/confirms/efgh_spec.rb"
    word_error = "spec/modals/confirXX/efgh_spec.rb"
    s = tsp.correct(word_error).first

    assert_equal s, word

    s = tsp.correct("spec/featuresXX")

    assert_equal "spec/features", s.first
  end

  def test_rake_dictionary
    dict = %w[parallel:prepare parallel:create parallel:rake parallel:migrate]
    word_error = "parallel:preprare"
    tsp = DidYouMean::TreeSpellChecker.new(dictionary: dict, separator: ":")
    s = tsp.correct(word_error).first

    assert_match s, "parallel:prepare"
  end

  def test_special_words_mini
    [
      %w(test/fixtures/book.rb                           test/fixture/book.rb),
      %w(test/edit_distance/jaro_winkler_test.rb         test/edit_distace/jaro_winkler_test.rb),
      %w(test/edit_distance/jaro_winkler_test.rb         teste/dit_distane/jaro_winkler_test.rb),
      %w(test/fixtures/book.rb                           test/fixturWes/book.rb),
      %w(test/test_helper.rb                             tes!t/test_helper.rb),
      %w(test/fixtures/book.rb                           test/hfixtures/book.rb),
      %w(test/edit_distance/jaro_winkler_test.rb         test/eidt_distance/jaro_winkler_test.@rb),
      %w(test/spell_checker_test.rb                      test/spell_checke@r_test.rb),
      %w(test/tree_spell_human_typo_test.rb              testt/ree_spell_human_typo_test.rb),
      %w(test/edit_distance/jaro_winkler_test.rb         test/edit_distance/jaro_winkler_tuest.rb),
    ].each do |expected, user_input|
      assert_tree_spell expected, input: user_input, dictionary: MINI_DIRECTORIES
    end

    [
      %w(test/spell_checking/variable_name_check_test.rb test/spell_checking/vriabl_ename_check_test.rb),
      %w(test/spell_checking/key_name_check_test.rb      tesit/spell_checking/key_name_choeck_test.rb),
    ].each do |expected, user_input|
      assert_equal expected, DidYouMean::TreeSpellChecker.new(dictionary: MINI_DIRECTORIES).correct(user_input)[0]
    end
  end

  def test_special_words_rspec
    [
      %w(spec/rspec/core/formatters/exception_presenter_spec.rb spec/rspec/core/formatters/eception_presenter_spec.rb),
      %w(spec/rspec/core/metadata_spec.rb                       spec/rspec/core/metadata_spe.crb),
      %w(spec/rspec/core/ordering_spec.rb                       spec/spec/core/odrering_spec.rb),
      %w(spec/support/mathn_integration_support.rb              spec/support/mathn_itegrtion_support.rb),
    ].each do |expected, user_input|
      assert_tree_spell expected, input: user_input, dictionary: RSPEC_DIRECTORIES
    end
  end

  def test_file_in_root
    assert_tree_spell "test/spell_checker_test.rb", input: "test/spell_checker_test.r", dictionary: MINI_DIRECTORIES
  end

  def test_no_plausible_states
    assert_tree_spell [], input: "testspell_checker_test.rb", dictionary: MINI_DIRECTORIES
  end

  def test_no_plausible_states_with_augmentation
    assert_tree_spell [], input: "testspell_checker_test.rb", dictionary: MINI_DIRECTORIES

    suggestions = DidYouMean::TreeSpellChecker.new(dictionary: MINI_DIRECTORIES, augment: true).correct("testspell_checker_test.rb")

    assert_equal "test/spell_checker_test.rb", suggestions.first
  end

  def test_no_idea_with_augmentation
    word_error = "test/spell_checking/key_name.rb"
    suggestions = DidYouMean::TreeSpellChecker.new(dictionary: MINI_DIRECTORIES).correct word_error

    assert_equal [], suggestions

    suggestions = DidYouMean::TreeSpellChecker.new(dictionary: MINI_DIRECTORIES, augment: true).correct word_error

    assert_equal "test/spell_checking/key_name_check_test.rb", suggestions.first
  end

  def test_works_out_suggestions
    exp = ["spec/models/concerns/vixen_spec.rb",
           "spec/models/concerns/vixenus_spec.rb"]
    suggestions = @tree_spell_checker.correct(@test_str)

    assert_equal suggestions.to_set, exp.to_set
  end

  def test_works_when_input_is_correct
    correct_input = "spec/models/concerns/vixenus_spec.rb"
    suggestions = @tree_spell_checker.correct correct_input

    assert_equal suggestions.first, correct_input
  end

  def test_find_out_leaves_in_a_path
    path = "spec/modals/confirms"
    names = @tree_spell_checker.send(:find_leaves, path)

    assert_equal names.to_set, %w[abcd_spec.rb efgh_spec.rb].to_set
  end

  def test_works_out_nodes
    exp_paths = ["spec/models/concerns",
                 "spec/models/confirms",
                 "spec/modals/concerns",
                 "spec/modals/confirms",
                 "spec/controllers/concerns",
                 "spec/controllers/confirms"].to_set
    states = @tree_spell_checker.dimensions
    nodes = states[0].product(*states[1..-1])
    paths = @tree_spell_checker.send(:possible_paths, nodes)

    assert_equal paths.to_set, exp_paths.to_set
  end

  def test_works_out_state_space
    suggestions = @tree_spell_checker.send(:plausible_dimensions, @test_str)

    assert_equal suggestions, [["spec"], %w[models modals], %w[confirms concerns]]
  end

  def test_parses_dictionary
    states = @tree_spell_checker.dimensions

    assert_equal states, [["spec"], %w[models modals controllers], %w[concerns confirms]]
  end

  def test_parses_elementary_dictionary
    dimensions = DidYouMean::TreeSpellChecker
                   .new(dictionary: %w(spec/models/user_spec.rb spec/services/account_spec.rb))
                   .dimensions

    assert_equal dimensions, [["spec"], %w[models services]]
  end

  private

  def assert_tree_spell(expected, input: , dictionary: )
    suggestions = DidYouMean::TreeSpellChecker.new(dictionary: dictionary).correct(input)

    assert_equal Array(expected), suggestions, "Expected to suggest #{expected}, but got #{suggestions.inspect}"
  end
end
