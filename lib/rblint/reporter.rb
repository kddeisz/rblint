# frozen_string_literal: true

module RbLint
  class Reporter
    def report_error
      print "\e[0;31;49mE\e[0m"
    end

    def report_failure
      print "\e[0;31;49mF\e[0m"
    end

    def report_success
      print "\e[0;32;49m.\e[0m"
    end

    def summarize(violations)
      puts

      if violations.any?
        violations.each do |path, path_violations|
          puts "#{path} ---\n\t#{path_violations.join("\n\t")}"
        end
      else
        puts 'No violations!'
      end
    end
  end
end
