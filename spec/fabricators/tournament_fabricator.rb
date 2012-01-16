Fabricator(:user) do
  username        'bob'
  email           'bob@dobbs.com'
  password        'monkey';  password_confirmation 'monkey'
end

Fabricator(:tournament) do
  name            'Greatest Pop Musician'
  size            64
end

Fabricator(:full_tournament, :from => :tournament) do
  user!
end

Fabricator(:bracket) do
  # tournament{ Fabricate(:full_tournament) }
end

Fabricator(:wing) do
  bracket
end
