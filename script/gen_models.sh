rm -f db/migrate/{0[12]?,00[6-9]}_*

nifty_opts=" --haml --rspec --skip-migration --force"
gen_opts="--old-style-hash --test-framework=rspec --fixture-replacement=machinist --fixture=false --force"

# rails g model          tournament name:string description:text user:belongs_to state:string $gen_opts
# rails g nifty:scaffold tournament name:string description:text user:belongs_to state:string $nifty_opts
# 
# rails g model          bracket    ordering:text closed:boolean tournament:belongs_to $gen_opts
# rails g nifty:scaffold bracket    ordering:text closed:boolean tournament:belongs_to $nifty_opts
# 
# rails g model          contestant name:string description:text bracket:belongs_to  $gen_opts
# rails g nifty:scaffold contestant name:string description:text bracket:belongs_to  $nifty_opts
# 
# rails g model          pool       $gen_opts --migration false 

rails g model          tround     $gen_opts --migration false
rails g model          tmatch     $gen_opts --migration false

# rails g model          ballot     outcomes:text bracket:belongs_to  $gen_opts
# rails g nifty:scaffold contestant name:string description:text bracket:belongs_to  $nifty_opts
