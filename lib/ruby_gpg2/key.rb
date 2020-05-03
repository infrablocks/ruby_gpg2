module RubyGPG2
  class Key
    attr_reader(
        :type,
        :validity,
        :length,
        :algorithm,
        :id,
        :creation_date,
        :owner_trust,
        :capabilities,
        :serial_number,
        :compliance_modes,
        :origin,
        :fingerprint,
        :user_ids)

    def initialize(opts)
      @type = opts[:type]
      @validity = opts[:validity]
      @length = opts[:length]
      @algorithm = opts[:algorithm]
      @id = opts[:id]
      @creation_date = opts[:creation_date]
      @owner_trust = opts[:owner_trust]
      @capabilities = opts[:capabilities]
      @serial_number = opts[:serial_number]
      @compliance_modes = opts[:compliance_modes]
      @origin = opts[:origin]
      @fingerprint = opts[:fingerprint]
      @user_ids = opts[:user_ids]
    end

    def primary_user_id
      @user_ids&.first
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [
          @type,
          @validity,
          @length,
          @algorithm,
          @id,
          @creation_date,
          @owner_trust,
          @capabilities,
          @serial_number,
          @compliance_modes,
          @origin,
          @fingerprint
      ]
    end
  end
end
