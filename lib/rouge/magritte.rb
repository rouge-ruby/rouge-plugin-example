require 'rouge' unless defined?(Rouge)

module RougeMagritte
  class Magritte < Rouge::RegexLexer
    # provide a unique tag
    tag 'magritte'

    # describe the language and link to a spec
    desc 'a Rouge lexer for the Magritte language (files.jneen.ca/academic/thesis.pdf)'

    # allows for aliases for e.g. markdown code blocks
    aliases 'mag'

    # list of filename patterns (can provide multiple)
    filenames '*.mag'

    # list of mimetypes
    mimetypes 'text/x-magritte', 'application/x-magritte'

    # manual detection - only return true if the input text is *100%* this language.
    # The argument `text` here is a TextAnalyzer with some helper methods on it for
    # the common use cases of shebangs and doctype tags.
    def self.detect?(text)
      return true if text.shebang?('magritte')
    end

    # provide a small (maybe 5-10 line) demo of the language
    demo <<~DEMO
    (iter ?f ?v) = (produce (=> put %v; %v = %f %v))

    iter-tree = (
      [node ?l ?r] => iter-tree $l; iter-tree $r
      [leaf ?v] => put $v
    )
    DEMO

    # This technique is common for large lists of keywords - rather than
    # constructing a huge regular expression, it makes more sense to match
    # a single word regex and do one check for set inclusion here.
    def self.builtins
      @builtins ||= Set.new %w(
        put get for fan each incr decr spawn shell str
        parse parse-pattern parse-command crash
      )
    end

    # If needed, put startup logic here - set up instance variables, push
    # states onto the stack, etc.
    start do
      # ...
    end

    # This is the top-level root state, where the lexer will start by default.
    state :root do
      rule /\s+/, Text
      rule /#/, Comment, :comment
      rule /[.][.][.]/, Comment
      rule /\$[\w-]+[?]?/, Name::Variable
      rule /[%][\w-]+[?]?/, Name::Variable
      rule /[?][\w-]+[?]?/, Name::Variable
      rule /[@][\w-]+[?]?/, Keyword
      rule /[@][!][\w-]+[?]?/, Comment::Preproc
      rule /[!][\w-]+[?]?/, Name::Property
      rule /&\d+/, Name::Tag

      rule /TODO|XXX/, Error
      rule /\d+([.]\d+)?(?!-)\b/, Num

      # using the block form of a rule allows us to check set inclusion at runtime.
      rule /[.\/\w-]+[?!]?/ do |m|
        if self.class.builtins.include?(m[0])
          token Name::Builtin
        else
          token Name
        end
      end

      rule /[*]/, Comment::Preproc

      rule /[(){}\[\]&|=;<>%+!]/, Punctuation
      rule /\\[(]/, Punctuation

      rule /"/, Str::Double, :dq
      rule /'/, Str::Single, :sq
    end

    state :comment do
      rule /TODO|XXX/, Error
      rule /\n/, Comment, :pop!

      rule /[^\n]+(?=TODO|XXX)/, Comment
      rule /[^\n]+/, Comment
    end

    state :dq do
      rule /"/, Str::Double, :pop!
      rule /[$][\w-]+/, Name::Variable
      rule /[^"$]+/, Str::Double
    end

    state :sq do
      rule /'/, Str::Single, :pop!
      rule /[^']+/, Str::Single
    end
  end
end
