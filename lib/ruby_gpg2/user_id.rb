# frozen_string_literal: true

module RubyGPG2
  class UserID
    attr_reader(
      :name,
      :comment,
      :email,
      :validity,
      :creation_date,
      :expiration_date,
      :hash,
      :origin
    )

    def initialize(opts)
      @name = opts[:name]
      @comment = opts[:comment]
      @email = opts[:email]
      @validity = opts[:validity]
      @creation_date = opts[:creation_date]
      @expiration_date = opts[:expiration_date]
      @hash = opts[:hash]
      @origin = opts[:origin]
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [
        @name,
        @comment,
        @email,
        @validity,
        @creation_date,
        @expiration_date,
        @hash,
        @origin
      ]
    end
  end
end
