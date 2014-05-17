require_relative 'test_helper'

class Project
  def self.bo0k
    Bo0k
  end
end

class Book
  class TableOfContents; end

  def tableof_contents
    TableofContents
  end

  class Page
    def tableof_contents
      TableofContents
    end

    def self.tableof_contents
      TableofContents
    end
  end
end

class SimpleSimilarClassFinderTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { ::Bo0k }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book")
  end
end

class SimilarClassFinderInsideClassTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { Project.bo0k }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book")
  end
end

class SimilarClassFinderInsideNestedClassTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { Book::Page.tableof_contents }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book::TableOfContents")
  end
end

class SimilarClassFinderForClassWithNamespaceTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { ::Book::TableofContents }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book::TableOfContents")
  end
end

class SimilarClassFinderFromInstanceTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { ::Book.new.tableof_contents }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book::TableOfContents")
  end
end

class SimilarClassFinderFromNestedInstanceTest < Minitest::Test
  def setup
    @error = assert_raises(NameError) { ::Book::Page.new.tableof_contents }
  end

  def test_similar_classes
    assert @error.method_finder.similar_classes.include?("Book::TableOfContents")
  end
end
