# frozen_string_literal: true

require "thor"
require "launchy"
require "blog_cli_2"
require "blog_cli_2/article"

module BlogCli2
  class CLI < Thor
    BLOG_URL = "https://ikuma-t.work"
    BLOG_PATH = ENV.fetch("BLOG_PATH", nil)

    class_option :help, type: :boolean, aliases: "-h", desc: "help message."

    desc "open", "Open blog in browser"
    def open
      options = { dry_run: ENV["LAUNCHY_DRY_RUN"] == "1" }
      Launchy.open(BLOG_URL, options)
    end

    desc "new <article>", "Create new article"
    option "editor", aliases: "-e", default: "ENV['EDITOR']=#{ENV.fetch("EDITOR")}", desc: "Open editor"
    option "title", aliases: "-t", desc: "Set 'title' in YAML Front-matter"
    def new(article)
      check_blog_path
      content = options[:title] ? header(title: options[:title]) : header
      File.write("#{BLOG_PATH}/#{article}.md", content)
      system("#{options[:editor]} #{BLOG_PATH}/#{article}.md")
    end

    desc "list", "Display last 5 articles"
    option "all", aliases: "-a", desc: "Show all articles"
    def list
      check_blog_path
      limit = options[:all] ? -1 : 5
      articles = Dir
                 .glob("#{BLOG_PATH}/*.md")
                 .map { |path| Article.new(path) }
                 .sort_by(&:published_at)
                 .reverse[0...limit]
                 .map { |article| [article.basename, article.title, article.published_at].join("\n   ├──") }
      puts articles
    end

    private

    def header(title: nil, date: Time.now)
      <<~HEADER
        ---
        title: "#{title}"
        date: "#{format(date)}"
        ---
      HEADER
    end

    def check_blog_path
      unless BLOG_PATH
        puts "環境変数BLOG_PATHが指定されていません"
        exit
      end
    end

    # ex: 2022-06-13 12:34:56
    def format(date)
      date.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
