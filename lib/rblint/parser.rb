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
      define_method(:"on_#{event}") do |token|
        [:"@#{event}", token]
      end
    end

    PARSER_EVENT_TABLE.each do |event, arity|
      if /_new\z/ =~ event && arity == 0
        alias_method :"on_#{event}", :_dispatch_event_new
      elsif /_add\z/ =~ event
        alias_method :"on_#{event}", :_dispatch_event_push
      else
        define_method(:"on_#{event}") do |*args|
          args.unshift(event)
        end
      end
    end
  end
end