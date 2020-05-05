require_relative 'status_lines'

module RubyGPG2
  class StatusLine
    TYPE_REGEX = /^\[GNUPG:\] (.*?)(\s|$)/

    TYPES = {
        "IMPORT_OK" => StatusLines::ImportOK,
        "IMPORT_PROBLEM" => StatusLines::ImportProblem,
        "IMPORTED" => StatusLines::Imported,
        "KEY_CREATED" => StatusLines::KeyCreated,
        "KEY_CONSIDERED" => StatusLines::KeyConsidered
    }

    def self.parse(line)
      TYPES
          .fetch(
              line.match(TYPE_REGEX)[1],
              StatusLines::Unimplemented)
          .parse(line)
    end
  end
end