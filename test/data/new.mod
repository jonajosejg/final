set HOURS ordered;
set DAYS = {1..ceil(card(HOURS)/24)};
set MONTHS = {1,2,3,4,5,6,7,8,9,10,11,12};

set BATTERY_TYPES;

param B_roundtrip_eff{BATTERY_TYPES};  
param B_depth_of_discharge{BATTERY_TYPES};
param B_power_rating{BATTERY_TYPES};
param charge_efficiency{b in BATTERY_TYPES}; 



