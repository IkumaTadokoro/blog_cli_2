# frozen_string_literal: true

require "spec_helper"
require "launchy"

RSpec.describe "Cli", type: :aruba do
  before { set_environment_variable "LAUNCHY_DRY_RUN", "1" }

  describe "#help" do
    expected = <<~EXPECTED
      Commands:
        blog help [COMMAND]  # Describe available commands or one specific command
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
end
