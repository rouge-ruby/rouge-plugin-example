require 'rouge' unless defined?(Rouge)

module RougeMagritte
  class Magritte < Rouge::RegexLexer
    desc 'a Rouge lexer for the Magritte language (files.jneen.ca/academic/thesis.pdf)'
    tag 'magritte'
    aliases 'mag'
    filenames '*.mag'

    mimetypes 'text/x-magritte', 'application/x-magritte'

    def self.detect?(text)
      return true if text.shebang?('magritte')
    end

    demo <<~DEMO
    (iter ?f ?v) = (produce (=> put %v; %v = %f %v))

    iter-tree = (
      [node ?l ?r] => iter-tree $l; iter-tree $r
      [leaf ?v] => put $v
    )
    DEMO

    def self.builtins
      @builtins ||= Set.new %w(
        put get for fan each incr decr spawn shell str
        parse parse-pattern parse-command crash
      )
    end

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

      # weird negative lookahead stuff is to not consider `-` as a word boundary
      rule /TODO|XXX/, Error
      rule /\d+([.]\d+)?(?!-)\b/, Num
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
