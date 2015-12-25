require 'email_verifier'

EmailVerifier.config do |config|
  config.verifier_email = "lee.jungdo@gmail.com"
end

puts EmailVerifier.check('zatrepalkova@edicex.cz')