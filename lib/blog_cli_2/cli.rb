# frozen_string_literal: true

require "thor"
require "launchy"
require "blog_cli_2"

module BlogCli2
  class CLI < Thor
    BLOG_URL = "https://ikuma-t.work"

    class_option :help, type: :boolean, aliases: "-h", desc: "help message."

    desc "open", "Open blog in browser"
    def open
      options = { dry_run: ENV["LAUNCHY_DRY_RUN"] == "1" }
      Launchy.open(BLOG_URL, options)
    end
  end
end