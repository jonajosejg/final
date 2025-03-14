# -------------------------------
# Sets
# -------------------------------
set HOURS ordered;                  # Hourly time periods (1-8760)
set BATTERY_TYPES;          # Battery technologies (e.g., Lithium_Ion)
set PV_TYPES;               # PV technologies (e.g., Mono_Si)
set MONTHS := 1..12;        # Months in a year
set ONPEAK within HOURS;    # On-peak hours (defined in .dat file)

# -------------------------------
# Parameters
# -------------------------------
# Battery Parameters
param B_rt_eff{BATTERY_TYPES};       # Round-trip efficiency
param B_dod{BATTERY_TYPES};          # Depth of discharge
param B_power_rating{BATTERY_TYPES}; # Power rating [kW]
param charge_efficiency{BATTERY_TYPES}; # Charging efficiency
param B_cost_e{BATTERY_TYPES};       # Energy capacity cost [$/kWh]
param B_cost_p{BATTERY_TYPES};       # Power capacity cost [$/kW]

# PV Parameters
param pv_eff_ref{PV_TYPES};          # Reference efficiency at STC
param temperature_coeff{PV_TYPES};   # Temperature coefficient [%/°C]
param pv_cost{PV_TYPES};             # Cost per kW of PV [$/kW]

# Hourly Parameters
param L{HOURS};                      # Energy consumption [kW]
param I{HOURS};                      # Solar insolation [kW/m²]
param temperature{HOURS};            # Ambient temperature [°C]
param cost_buy;                      # Electricity purchase price [$/kWh]
param T_c{HOURS};                    # Cell temperature [°C]
param month_of{HOURS} within MONTHS; # Month for each hour

# Tariff Parameters
param BASE_DEMAND_RATE;              # $/kW (on-peak demand)
param MAX_DEMAND_RATE;               # $/kW (overall demand)
param FIXED_MONTHLY_CHARGE;          # Fixed monthly charge [$]
param cost_sell;                     # Sell-back rate [$/kWh]
param lambda;                        # Regularization penalty

# System Parameters
param P_pv;                          # Installed PV capacity [kW]

# -------------------------------
# Variables
# -------------------------------
# Energy Flow Variables
var P_buy_L{HOURS} >= 0;             # Grid power for load [kW]
var P_grid_charge{HOURS} >= 0;       # Grid power for charging [kW]
var PV_gen{HOURS} >= 0;              # Total PV generation [kW]
var PV_gen_G{HOURS} >= 0;            # PV power sold to grid [kW]
var PV_gen_L{HOURS} >= 0;            # PV power used locally [kW]
var PV_gen_b{HOURS} >= 0;            # PV power for battery charging [kW]

# Battery Variables
var SOC{HOURS} >= 0;                 # State of charge [kWh]
var P_charge{HOURS} >= 0;            # Battery charging power [kW]
var P_discharge{HOURS} >= 0;         # Battery discharging power [kW]
var B_grid{HOURS} >= 0;              # Battery discharge to grid [kW]

# Capacity Variables
var Capacity{BATTERY_TYPES} >= 0;    # Battery energy capacity [kWh]
var Power{BATTERY_TYPES} >= 0;       # Battery power capacity [kW]

# Demand Charge Variables
var P_monthly_onpeak{MONTHS} >= 0;   # Monthly on-peak max demand [kW]
var P_monthly_overall{MONTHS} >= 0;  # Monthly overall max demand [kW]

# Regularization Variables
var diff_pos{HOURS} >= 0;            # Positive SOC difference
var diff_neg{HOURS} >= 0;            # Negative SOC difference

# -------------------------------
# Objective Function
# -------------------------------
minimize Total_Cost:
    # Annualized upfront costs
    (sum{t in PV_TYPES} (2000 * pv_cost[t])) / 20 
    + (sum{b in BATTERY_TYPES} (Capacity[b] * B_cost_e[b] + Power[b] * B_cost_p[b])) / 20
    
    # Energy costs
    + sum{h in HOURS} (cost_buy * (P_buy_L[h] + P_grid_charge[h]))
    
    # Demand charges
    + sum{m in MONTHS} (
        12.9 * P_monthly_onpeak[m]
        + 0.823 * P_monthly_overall[m]
        + 89.26
    )
    
    # Revenue from energy sales
    - sum{h in HOURS} (cost_sell * (PV_gen_G[h] + B_grid[h]))
    
    # Regularization term
    + 0.1 * sum{h in HOURS: ord(h) < card(HOURS)} (diff_pos[h] + diff_neg[h]);

# ----------------------------
# Constraints
# -------------------------------
# Power Balance
subject to Power_Balance{h in HOURS}:
    P_buy_L[h] + PV_gen_L[h] + P_discharge[h] = L[h] + P_charge[h];

# PV Generation Allocation
subject to PV_Allocation{h in HOURS}:
    PV_gen[h] = PV_gen_L[h] + PV_gen_G[h] + PV_gen_b[h];

# PV Generation Limit
subject to PV_Generation{h in HOURS}:
    PV_gen[h] <= P_pv * pv_eff_ref["Mono_Si"] 
        * (1 + (temperature_coeff["Mono_Si"]/100) * (T_c[h] - 25));

# Battery SOC Dynamics
subject to SOC_Update{h in HOURS}:
    SOC[h] = if h = 1 then 0
        else SOC[h-1] 
            + (P_charge[h-1] * charge_efficiency["Lithium_Ion"] 
            - P_discharge[h-1] / B_rt_eff["Lithium_Ion"]);

# Demand Charge Tracking
subject to OnPeak_Demand{m in MONTHS, h in ONPEAK: month_of[h] = m}:
    P_monthly_onpeak[m] >= L[h] + P_charge[h] - PV_gen_L[h];

subject to Overall_Demand{m in MONTHS, h in HOURS: month_of[h] = m}:
    P_monthly_overall[m] >= L[h] + P_charge[h] - PV_gen_L[h];

# Regularization Constraints
subject to Smoothing{h in HOURS: ord(h) < card(HOURS)}:
    SOC[h+1] - SOC[h] = diff_pos[h] - diff_neg[h];
