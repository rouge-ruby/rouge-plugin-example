require_relative 'spec_helper'

class RougeMagritteTest < Minitest::Test
  def test_extension_guess
    assert_equal Rouge::Lexer.guess(filename: 'foo.mag'), RougeMagritte::Magritte
  end

  def test_shebang_guess
    assert_equal Rouge::Lexer.guess(source: "#!/usr/bin/env magritte"), RougeMagritte::Magritte
  end

  def test_mimetype_guess
    assert_equal Rouge::Lexer.guess(mimetype: 'text/x-magritte'), RougeMagritte::Magritte
    assert_equal Rouge::Lexer.guess(mimetype: 'application/x-magritte'), RougeMagritte::Magritte
  end

  def test_lexes_demo
    # [jneen] this should be .demo, waiting for bugfix in:
    # https://github.com/rouge-ruby/rouge/pull/2218
    demo_text = RougeMagritte::Magritte.instance_variable_get(:@demo)

    fulltext = []

    RougeMagritte::Magritte.lex(demo_text) do |tok, text|
      fulltext << text
      refute_equal tok.qualname, 'Error'
    end

    assert_equal fulltext.join, demo_text
  end

  def test_lexes_sample
    sample_text = File.read("#{__dir__}/visual/samples/magritte", encoding: 'utf-8')

    fulltext = []

    RougeMagritte::Magritte.lex(sample_text) do |tok, text|
      fulltext << text
    end

    assert_equal fulltext.join, sample_text
  end
end
