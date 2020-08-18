# frozen_string_literal: true

require 'ripper'

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
