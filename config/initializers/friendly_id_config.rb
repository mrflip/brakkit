FriendlyId.defaults do |config|
  config.use :reserved
  config.reserved_words = %w[
    new edit update delete destroy show index
    user password login logout signup session
    tag tags category categories
    bracket tournament tmatch tround contestant vote
  ]
end
