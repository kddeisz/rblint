# frozen_string_literal: true

module RbLint
  module Rules
    # Detects assigning values inside of conditions. For example:
    #
    #     bar if foo = 1
    #
    module AssignmentInCondition
      %i[case elsif if unless until while].each do |event|
        define_method(:"on_#{event}") do |predicate, *others|
          if %i[assign massign].include?(predicate[0])
            violation('Assignment found inside a condition.')
          end

          super(predicate, *others)
        end
      end
    end

    # Detects case clauses that are duplicated. For example:
    #
    #     case foo
    #     when :one, :one
    #       1
    #     end
    #
    module DuplicateCaseCondition
      def on_case(predicate, following)
        clauses = clauses_from(following)

        if clauses.uniq.length != clauses.length
          violation('Duplicate case clauses found.')
        end

        super
      end

      private

      def clauses_from(clause)
        case clause
        in [:when, args, _, following]
          args + clauses_from(following)
        in [:in, args, _, following]
          clauses_from(following)
        else
          []
        end
      end
    end

    # Detects literal values used inside conditions. For example:
    #
    #     foo if 1
    #
    module LiteralAsCondition
      %i[case elsif if unless until while].each do |event|
        define_method(:"on_#{event}") do |predicate, *others|
          if literal?(predicate)
            violation('Literal found inside a condition.')
          end

          super(predicate, *others)
        end
      end

      private

      def literal?(node)
        case node
        in [:@int, *] | [:var_ref, [:@kw, 'true' | 'false']]
          true
        in [:binary, left, :"||", right]
          literal?(left) || literal?(right)
        else
          false
        end
      end
    end

    # Return a module containing all of the configured rules
    def self.from(config)
      config.default = { 'Enabled' => true }

      Module.new do
        Rules.constants.each do |constant|
          include(Rules.const_get(constant)) if config[constant.to_s]['Enabled']
        end
      end
    end
  end
end
