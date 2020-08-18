# frozen_string_literal: true

module RbLint
  class Runner
    attr_reader :reporter

    def initialize(reporter = Reporter.new)
      @reporter = reporter
    end

    def run(pattern, config = {})
      rules = Rules.from(config)
      violations = {}

      Dir.glob(pattern).each do |path|
        parser = Parser.new(File.read(path))

        parser.singleton_class.prepend(rules)
        parser.parse

        if parser.error?
          violations[path] = ['Could not parse.']
          reporter.report_error
        elsif parser.violations.any?
          violations[path] = parser.violations.map(&:to_s)
          reporter.report_failure
        else
          reporter.report_success
        end
      end

      reporter.summarize(violations)
    end
  end
end
