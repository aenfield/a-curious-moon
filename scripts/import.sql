CREATE SCHEMA IF NOT EXISTS import;

DROP TABLE IF EXISTS import.master_plan;
CREATE TABLE import.master_plan(
    start_time_utc TEXT,
    duration TEXT,
    date TEXT,
    team TEXT,
    spass_type TEXT,
    target TEXT,
    request_name TEXT,
    library_definition TEXT,
    title TEXT,
    description TEXT
);

DROP TABLE IF EXISTS import.inms CASCADE;
CREATE TABLE import.inms(
    sclk TEXT,
    uttime TEXT,
    target TEXT,
    time_ca TEXT,
    targ_pos_x TEXT,
    targ_pos_y TEXT,
    targ_pos_z TEXT,
    source TEXT,
    data_reliability TEXT,
    table_set_id TEXT,
    coadd_cnt TEXT,
    osp_fil_1_status TEXT,
    oss_fil_2_status TEXT,
    csp_fil_3_status TEXT,
    css_fil_4_status TEXT,
    seq_table TEXT,
    cyc_num TEXT,
	cyc_table text,
	scan_num text,
	trap_table text,
	sw_table text,
	mass_table text,
	focus_table text,
	da_table text,
	velocity_comp text,
	ipnum text,
	mass_per_charge text,
	os_lens2 text,
	os_lens1 text,
	os_lens4 text,
	os_lens3 text,
	qp_lens2 text,
	qp_lens1 text,
	qp_lens4 text,
	qp_lens3 text,
	qp_bias text,
	ion_defl2 text,
	ion_defl1 text,
	ion_defl4 text,
	ion_defl3 text,
	top_plate text,
	p_energy text,
	alt_t text,
	view_dir_t_x text,
	view_dir_t_y text,
	view_dir_t_z text,
	sc_pos_t_x text,
	sc_pos_t_y text,
	sc_pos_t_z text,
	sc_vel_t_x text,
	sc_vel_t_y text,
	sc_vel_t_z text,
	sc_vel_t_scx text,
	sc_vel_t_scy text,
	sc_vel_t_scz text,
	lst_t text,
	sza_t text,
	ss_long_t text,
	distance_s text,
	view_dir_s_x text,
	view_dir_s_y text,
	view_dir_s_z text,
	sc_pos_s_x text,
	sc_pos_s_y text,
	sc_pos_s_z text,
	sc_vel_s_x text,
	sc_vel_s_y text,
	sc_vel_s_z text,
	lst_s text,
	sza_s text,
	ss_long_s text,
	sc_att_angle_ra text,
	sc_att_angle_dec text,
	sc_att_angle_tw text,
	c1counts text,
	c2counts text
);

DROP TABLE IF EXISTS import.cda;
CREATE TABLE import.cda (
    event_id TEXT,
    impact_event_time TEXT,
    impact_event_julian_date TEXT,
    qp_amplitude TEXT,
    qi_amplitude TEXT,
    qt_amplitude TEXT,
    qc_amplitude TEXT,
    spacecraft_sun_distance TEXT,
    spacecraft_saturn_distance TEXT,
    spacecraft_x_velocity TEXT,
    spacecraft_y_velocity TEXT,
    spacecraft_z_velocity TEXT,
    counter_number TEXT,
    particle_mass TEXT,
    particle_charge TEXT
);

DROP TABLE IF EXISTS flybys CASCADE;
CREATE TABLE flybys (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    date DATE NOT NULL,
    altitude NUMERIC(7,1),
    speed NUMERIC(7,1)
);

DROP TABLE IF EXISTS chem_data CASCADE;
CREATE TABLE chem_data (
    name TEXT,
    formula VARCHAR(10),
    molecular_weight INTEGER,
    peak INTEGER,
    sensitivity NUMERIC
);

