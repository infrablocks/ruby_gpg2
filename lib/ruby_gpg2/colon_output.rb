# frozen_string_literal: true

require_relative 'colon_record'
require_relative 'key'

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
      group_by_type(:secret_key)
        .map { |record_group| extract_key(:secret, record_group) }
    end

    def public_keys
      group_by_type(:public_key)
        .map { |record_group| extract_key(:public, record_group) }
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [@records]
    end

    private

    def indices_by_type(type)
      @records
        .each_with_index
        .collect { |record, index| record.type == type ? index : nil }
        .compact
    end

    def group_by_type(type)
      indices = indices_by_type(type)
      indices << @records.count

      groups = []
      indices.each_cons(2) do |index_pair|
        groups << @records[index_pair[0]...index_pair[1]]
      end
      groups
    end

    def extract_key(type, record_group)
      key_record = record_group[0]
      fingerprint = extract_fingerprint(record_group)
      user_ids = extract_user_ids(record_group)

      make_key(type, key_record, fingerprint, user_ids)
    end

    def extract_user_ids(record_group)
      user_id_records =
        record_group
        .drop_while { |r| !r.user_id_record? }
        .take_while(&:user_id_record?)
      user_id_records.map(&method(:make_user_id))
    end

    def extract_fingerprint(record_group)
      records_in_group = record_group.count
      fingerprint_record =
        if records_in_group > 1 && record_group[1].fingerprint_record?
          record_group[1]
        end
      fingerprint_record&.fingerprint
    end

    def make_user_id(record)
      UserID.new(
        name: record.user_name,
        comment: record.user_comment,
        email: record.user_email,
        validity: record.validity,
        creation_date: record.creation_date,
        expiration_date: record.expiration_date,
        hash: record.user_id_hash,
        origin: record.origin
      )
    end

    # rubocop:disable Metrics/MethodLength
    def make_key(type, key_record, fingerprint, user_ids)
      Key.new(
        type:,
        validity: key_record.validity,
        length: key_record.key_length,
        algorithm: key_record.key_algorithm,
        id: key_record.key_id,
        creation_date: key_record.creation_date,
        owner_trust: key_record.owner_trust,
        capabilities: key_record.key_capabilities,
        serial_number: key_record.serial_number,
        compliance_modes: key_record.compliance_modes,
        origin: key_record.origin,
        fingerprint:,
        user_ids:
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
