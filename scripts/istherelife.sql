SELECT
    flybys.name AS flyby,
    inms.chem_data.name,
    source,
    SUM(high_counts) AS high_counts,
    SUM(low_counts) AS low_counts
FROM flybys
INNER JOIN inms.readings 
    ON time_stamp >= flybys.window_start
    AND time_stamp <= flybys.window_end
INNER JOIN inms.chem_data
    ON peak = mass_per_charge
WHERE
    flybys.targeted = true
    AND formula in ('H2','CH4','CO2','H2O')
GROUP BY 
    flybys.id,
    flybys.name,
    inms.chem_data.name,
    source
ORDER BY flybys.id; 
