# frozen_string_literal: true

require "blog_cli_2"
require "ruby_matter"

module BlogCli2
  class Article
    attr_reader :meta

    def initialize(pathname)
      @pathname = pathname
      @meta = RubyMatter.read(pathname)
    end

    def basename
      File.basename(@pathname, ".*")
    end

    def title
      front_matter["title"]
    end

    def published_at
      front_matter["date"]
    end

    private

    def front_matter
      @meta.data
    end
  end
end
