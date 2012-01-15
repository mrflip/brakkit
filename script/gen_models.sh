nifty_opts=" --haml --rspec --skip-migration --force"
gen_opts="--old-style-hash --test-framework=rspec --fixture-replacement=machinist --fixture=false --force"

# rm -f db/migrate/{0[12]?,00[6-9]}_*

# rails g model          tournament name:string size:integer description:text user:belongs_to state:string handle:string settings:text $gen_opts
# rails g nifty:scaffold tournament name:string size:integer description:text user:belongs_to state:string handle:string settings:text $nifty_opts

# rails g model          bracket    ordering:text closed:boolean tournament:belongs_to handle:string settings:text $gen_opts
# rails g nifty:scaffold bracket    ordering:text closed:boolean tournament:belongs_to handle:string settings:text $nifty_opts

rails g model          contestant name:string description:text bracket:belongs_to seed:integer handle:string settings:text $gen_opts
rails g nifty:scaffold contestant name:string description:text bracket:belongs_to seed:integer handle:string settings:text $nifty_opts

# rails g model          pool       handle:string $gen_opts --migration false 
# 
# rails g model          tround     handle:string $gen_opts --migration false
# rails g model          tmatch     handle:string $gen_opts --migration false

# rails g model          ballot     handle:string outcomes:text bracket:belongs_to  $gen_opts

