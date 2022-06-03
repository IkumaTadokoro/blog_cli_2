# frozen_string_literal: true

require "spec_helper"
require "launchy"
require "timecop"

RSpec.describe "Cli", type: :aruba do
  before { set_environment_variable "LAUNCHY_DRY_RUN", "1" }

  describe "#help" do
    expected = <<~EXPECTED
      Commands:
        blog help [COMMAND]  # Describe available commands or one specific command
        blog new <article>   # Create new article
        blog open            # Open blog in browser

      Options:
        -h, [--help], [--no-help]  # help message.
    EXPECTED

    before { run_command("blog help") }

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end

  describe "#open" do
    before { run_command("blog open") }

    it { expect(last_command_started).to be_successfully_executed }
  end

  describe "new" do
    context "when ENV['BLOG_PATH'] is specified" do
      before do
        set_environment_variable "BLOG_PATH", File.expand_path("../tmp/aruba", __dir__)
        # TODO: なんで時が止まらないんですかね？
        Timecop.freeze(Time.parse("2022-06-03 19:00:00"))
      end

      after { Timecop.return }

      let!(:content) do
        <<~CONTENT
          ---
          title: "#{title}"
          date: "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
          ---
        CONTENT
      end

      context "when any options are NOT specified" do
        before { run_command("blog new new_sample") }
        let!(:title) { nil }
        file = "new_sample.md"
        it { expect(last_command_started).to be_successfully_executed }
        it { expect(file).to have_file_content content }
      end

      context "when -e, [--edit] option is specified" do
        before { run_command("blog new new_sample_with_editor -e") }
        let!(:title) { nil }
        file = "new_sample_with_editor.md"
        it { expect(last_command_started).to be_successfully_executed }
        it { expect(file).to have_file_content content }
      end

      context "when -t, [--title] option is specified" do
        before { run_command("blog new new_sample_with_title -t 新しいサンプル記事") }
        let!(:title) { "新しいサンプル記事" }
        file = "new_sample_with_title.md"
        it { expect(last_command_started).to be_successfully_executed }
        it { expect(file).to have_file_content content }
      end
    end

    context "when ENV['BLOG_PATH'] is NOT specified" do
      before { run_command("blog new new_sample") }
    end
  end
end
