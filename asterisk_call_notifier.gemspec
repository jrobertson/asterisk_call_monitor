Gem::Specification.new do |s|
  s.name = 'asterisk_call_notifier'
  s.version = '0.1.2'
  s.summary = 'This gem actively monitors Asterisk\'s CDR CSV file (using tail -f) and publishes the latest entry to a SimplePubSub messaging broker.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/asterisk_call_notifier.rb']
  s.add_runtime_dependency('sps-pub', '~> 0.4', '>=0.4.0') 
  s.signing_key = '../privatekeys/asterisk_call_notifier.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/asterisk_call_notifier'
end
