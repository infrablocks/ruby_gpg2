require_relative './colon_record'
require_relative './key'

module RubyGPG2
  class ColonOutput
    def self.parse(records)
      new(records
          .strip
          .split("\n")
          .collect { |record| ColonRecord.parse(record) })
    end

    def initialize(records)
      @records = records
    end

    def secret_keys
      []
    end

    def public_keys
      public_key_indices = @records
          .each_with_index
          .collect { |record, index|
            record.type == :public_key ? index : nil
          }
          .compact << @records.count

      public_key_record_groups = []
      public_key_indices.each_cons(2) do |index_pair|
        public_key_record_groups <<
            @records[index_pair[0]...index_pair[1]]
      end

      public_key_record_groups.map do |record_group|
        records_in_group = record_group.count
        public_key_record = record_group[0]

        fingerprint_record =
            (records_in_group > 1 && record_group[1].fingerprint_record?) ?
                record_group[1] :
                nil
        fingerprint = fingerprint_record&.fingerprint

        user_id_records = record_group
            .drop_while { |r| !r.user_id_record? }
            .take_while { |r| r.user_id_record? }
        user_ids = user_id_records.map do |record|
          UserID.new(
              name: record.user_name,
              comment: record.user_comment,
              email: record.user_email,
              validity: record.validity,
              creation_date: record.creation_date,
              expiration_date: record.expiration_date,
              hash: record.user_id_hash,
              origin: record.origin)
        end

        Key.new(
            type: :public,
            validity: public_key_record.validity,
            length: public_key_record.key_length,
            algorithm: public_key_record.key_algorithm,
            id: public_key_record.key_id,
            creation_date: public_key_record.creation_date,
            owner_trust: public_key_record.owner_trust,
            capabilities: public_key_record.key_capabilities,
            compliance_modes: public_key_record.compliance_modes,
            origin: public_key_record.origin,
            fingerprint: fingerprint,
            user_ids: user_ids)
      end
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [@records]
    end
  end
end