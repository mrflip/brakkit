### Tournament

This is the main organizing object for a `bracket` (the ordered contestants folks will vote on) and its `ballot`s (the secondary orderings that people submit).

* A Tournament is in `development` until its owner marks it as her primary tournament. Other people can see it (subject to visibility), but nobody can vote on it.
* Once the owner makes it go `live` for balloting, it is open for voting. The contestants, ordering and most other elements of a tournament are frozen. You can only have one `live` tournament at a time.
* After `duration` days, the tournament is `finished`
* At that point, we run a `Simulation` and announce the `FinalTruth`. Humankind just got a little bit smarter and a little more awesome.

    attr        :name
    attr        :description
    
    belongs_to  :user
    has_one     :bracket
    has_many    :ballots
    
### Contestant

The elements a tournament intends to rank. 

Contestants are unique to each bracket, so if 'James Brown' were in a tournament for 'Greatest Band or Artist' and another one for 'Crazy People' he'd have two different entries.

    attr        :name
    attr        :description
    
    belongs_to  :bracket
    
    def         bubble?() ; end
    def         closed?() bracket.closed? ; end
    def         seed

### Bracket

A bracket organizes contestants into a set of matchups.

* `contestants` -- up to twice as many as the tournament size.
* `seeding`     -- the order of those contestants. 
* `bubble`      -- contestants with higher seeds than the tournament size. The ordering of contestants on the bubble is arbitrary, but useful for bracket development.

A bracket is the direct owner for its contestants. However it also provides several proxy containers:

* `wing`s       -- groups rounds into east, west, roundup, etc.
* `tround`s     -- holds the matches at each stage

    attr        :ordering
    attr        :closed

    has_many    :t_rounds
    belongs_to  :tournament
    belongs_to  :user, :through => :tournament
    has_many    :contestants
    has_many    :tags

### Pool

A proxy container for contestants -- holds contestants in seed order 

    def         contestants

### TRound

    def         t_matches
    def         wing
    def         contestants
    
### TMatch

    attr        :contestant_a
    attr        :contestant_b
    
    def         contestants
    def         t_round
    def         bracket
    def         winner
    def         final_match?

### Ballot

    attr        :outcomes

    belongs_to  :tournament
    belongs_to  :user

### Simulation

    belongs_to  :tournament


### Authentication flow


* Facebook
  - username 
  - fullname
  - email
  - description
  - 
  - facebook_id
  - facebook_url
  - photo
  
* Twitter
  - username
  - fullname
  - url
  - description
  - 
  - twitter_name
  - photo

* Google
  - email
  - fullname
  - location

* Regular login


* twitter auth callback:
  - fetch identity.
  - if identity exists 
    - and identity's user exists -- sign in as that user
    - and user signed in         -- pair identity with that user
    - else                       -- 




According to our [typography study](http://www.smashingmagazine.com/2009/08/20/typographic-design-survey-best-practices-from-the-best-blogs/):
* Line height (in pixels) ÷ body copy font size (in pixels) = 1.48 -- 1.5 is commonly recommended in classic typographic books, so our study backs up this rule of thumb. Very few websites use anything less than this. And the number of websites that go over 1.48 decreases as you get further from this value.
* Line length (pixels) ÷ line height (pixels) = 27.8               -- The average line length is 538.64 pixels (excluding margins and padding), which is pretty large considering that many websites still have body copy that is 12 to 13 pixels in font size.
* Space between paragraphs (pixels) ÷ line height (pixels) = 0.754 -- It turns out that paragraph spacing (i.e. the space between the last line of one paragraph and the first line of the next) rarely equals the leading (which would be the main characteristic of perfect vertical rhythm). More often, paragraph spacing is just 75% of paragraph leading. The reason may be that leading usually includes the space taken up by descenders; and because most characters do not have descenders, additional white space is created under the line.
* Optimal number of characters per line is 55 to 75                -- According to classic typographic books, the optimal number of characters per line is between 55 and 75, but between 75 and 85 characters per line is more popular in practice.
* Heading font size ÷ Body copy font size = 1.96                   -- When you have chosen a font size for your body copy, you may want to multiply it by 2 to get your heading font size. This, of course, depends on your style; the rule of thumb won’t necessarily give you the optimal size for your particular design. Another option is to use a traditional scale (6, 7, 8, 9, 10, 11, 12, 14, 16, 18, 21, 24, 36, 48, 60, 72) or the Fibonacci sequence (e.g. 16 – 24 – 40 – 64 – 104) to get natural typographic results.

According to our [web form study](http://www.smashingmagazine.com/2008/07/04/web-form-design-patterns-sign-up-forms/)
* The registration link is titled “sign up” (40%) and is placed in the upper-right corner.
* Sign-up forms have simple layouts, to avoid distracting users (61%).
* Titles of input fields are bolded (62%), and fields are vertically arranged more than they are horizontally arranged (86%).
* Designers tend to include few mandatory fields and few optional fields.
* Email confirmation is not given (82%), but password confirmation is (72%).
* The “Submit” button is either left-aligned (56%) or centered (26%).

More:
* COMBAT SPAM BY HIDING A TEXT FIELD WITH JAVASCRIPT, INSTEAD OF USING CAPTCHA -- If you get a lot of spam, then putting a CAPTCHA on your form may be necessary. What’s not necessary is making the CAPTCHA an obstacle that turns users away. Traditional CAPTCHAs that ask users to retype distorted letters have been proven to hurt conversion rates. With the extra hassle they force on users, it’s no wonder.
* USE A QUESTION MARK ICON FOR THE PASSWORD RECOVERY LINK -- Users should have no trouble finding the password recovery link on your form. Instead of using a “Forgot your password” link, consider using a simple question mark button, which won’t take up a lot of room or get lost among other links. Because the question mark is a universal symbol for help, users will not wonder where to go when they’re having password trouble.
* MAKE THE “SUBMIT” BUTTON AS WIDE AS THE TEXT FIELDS -- The log-in button isn’t just for taking action: it also lets users know what action they’re about to take. A small log-in button has weak affordance and can make users feel uncertain about logging in. A wide button gives users more confidence and is hard to miss. The button’s label also becomes more visible, so that users are clearer about the action they’re taking.


```
  before_filter :memorize_user
  def memorize_user
    return unless current_user
    past_users = cookies["brakkit.users_seen"].to_s.split
    user_id    = current_user && current_user.id
    new_val = [past_users, user_id.to_s].flatten.uniq.compact.join(' ')
    Rails.dump(past_users, user_id, cookies, new_val)
    cookies.permanent["brakkit.users_seen"] = new_val
  end
```
