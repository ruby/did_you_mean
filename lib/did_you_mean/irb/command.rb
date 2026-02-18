# frozen_string_literal: true

# Registers the `fix` command with IRB

require "irb/command"

::IRB::Command._register_with_aliases(
  :irb_fix,
  DidYouMean::IRB::FixCommand,
  [:fix, ::IRB::Command::NO_OVERRIDE]
)
