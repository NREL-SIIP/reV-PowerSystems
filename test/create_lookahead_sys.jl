using PowerSystems

sys = System(0, enable_compression=true)
add_component!(sys, Bus(nothing))
for i in 1:3
    plant = RenewableDispatch(nothing)
    set_name!(plant, "plant$i")
    add_component!(sys, plant)
end

# required_metadata

metadata_file = "data/siip_lookahead_metadata.json"
add_time_series!(sys, metadata_file)
to_json(sys, "lookahead_system/sys.json", force=true)

using Plots
pyplot()
td = get_time_series(
    Deterministic,
    get_component(RenewableDispatch, sys, "plant1"),
    "max_active_power"
)

for window in iterate_windows(td)
    plot!(window, legend=false, color=:black)
end

savefig("lookahead_system/plant1_max_active_power.png")
