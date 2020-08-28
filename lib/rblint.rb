# frozen_string_literal: true

require 'ripper'

# A lot of the rules use pattern matching to match against ripper's statements,
# so it's kind of annoying to get constant warnings about pattern matching being
# experimental. Turning it off here.
Warning.singleton_class.prepend(
  Module.new do
    def warn(warning)
      super unless warning.include?('experimental')
    end
  end
)

require 'rblint/version'
require 'rblint/parser'
require 'rblint/rules'
require 'rblint/reporter'
require 'rblint/runner'

module RbLint
  def self.lint(pattern, config = {})
    Runner.new.run(pattern, config)
  end
end
