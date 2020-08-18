# frozen_string_literal: true

module RbLint
  class Parser < Ripper::SexpBuilderPP
    Violation = Struct.new(:message, :lineno, :column)

    def violations
      @violations ||= []
    end

    private

    def violation(message)
      violations << Violation.new(message, lineno, column)
    end

    def _dispatch_event_new
      []
    end

    def _dispatch_event_push(list, item)
      list.push(item)
    end

    SCANNER_EVENTS.each do |event|
      define_method(:"on_#{event}") { |token| [:"@#{event}", token] }
    end

    PARSER_EVENT_TABLE.each do |event, arity|
      if /_new\z/ =~ event && arity == 0
        alias_method :"on_#{event}", :_dispatch_event_new
      elsif /_add\z/ =~ event
        alias_method :"on_#{event}", :_dispatch_event_push
      else
        define_method(:"on_#{event}") { |*args| args.unshift(event) }
      end
    end

    def on_if_mod(predicate, statements)
      on_if(predicate, statements, nil)
    end

    def on_unless_mod(predicate, statements)
      on_unless(predicate, statements, nil)
    end

    alias_method :on_while_mod, :on_while
    alias_method :on_until_mod, :on_until
  end
end
