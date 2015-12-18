module DidYouMean
  TRACE.enable
  SPELL_CHECKERS['NoMethodError'].prepend(MethodNameChecker::IvarNameCorrectable)
end
