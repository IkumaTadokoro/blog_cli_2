# frozen_string_literal: true

require "spec_helper"
require "launchy"

RSpec.describe "Cli", type: :aruba do
  before { set_environment_variable "LAUNCHY_DRY_RUN", "1" }

  describe "#open" do
    before { run_command("blog open") }

    it { expect(last_command_started).to be_successfully_executed }
  end
end
