Fabricator(:user) do
  username        'bob'
  email           'bob@dobbs.com'
  password        'monkey';  password_confirmation 'monkey'
end

Fabricator(:tournament) do
  name            'Greatest Pop Musician'
  handle          'tournament_1'
  size            64
end

# Fabricator(:full_tournament, :from => :tournament) do
#   user!         { Fabricate(:user) }
#   name            'Greatest Pop Musician'
#   size            64
#   duration        7
#   visibility      0
#   state           'development'
# end
