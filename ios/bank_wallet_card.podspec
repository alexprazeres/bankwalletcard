Pod::Spec.new do |s|
  s.name             = 'BANK_WALLET_CARD'
  s.version          = '1.0.0'
  s.summary          = 'Bank Wallet Card'
  s.homepage         = '2gofintech.io'
  s.license          = { :type => 'BSD' }
  s.author           = { 'MY TEAM' => 'team@myteam.com' }
  s.source           = { :path => "file:///Users/alexandreprazeres/Documents/2GO/bank_wallet_card", :version => s.version.to_s }
  s.ios.deployment_target = '11.0'
  # Framework linking is handled by Flutter tooling, not CocoaPods.
  # Add a placeholder to satisfy `s.dependency 'Flutter'` plugin podspecs.
end  