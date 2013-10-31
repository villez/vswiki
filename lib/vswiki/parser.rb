require 'active_support/core_ext'

module Vswiki
  class Parser

    # more complex handling for special characters is needed
    # in the future, but ActiveSupport's titleize + whitespace
    # removal is a decent starting point
    def self.make_wikititle(str)
      str.titleize.gsub(/\s+/, "") if str
    end
  end
end
