# frozen_string_literal: true

module Errors
  module Serializer
    extend self

    Message = -> data do
      String(data.respond_to?(:message) ? data.message : data)
    end

    def call(messages)
      { error: Array(messages).map(&Message) }
    end

    alias_method :[], :call
  end
end
