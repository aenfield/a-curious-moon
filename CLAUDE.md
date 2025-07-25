# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Claude generated this overview after I'd set up the database by finishing chapter two, but before I did anything further. It seems to be relatively right, at least.

## Project Overview

"A Curious Moon" is a PostgreSQL-based data warehouse that processes space mission data from NASA's Cassini spacecraft mission to Saturn and its moons. The project transforms CSV data sources into a normalized relational database following dimensional modeling principles.

## Key Commands

### Database Setup

```bash
# Create the database (run once)
createdb enceladus

# Full pipeline execution
make all

# Individual build steps
make clean      # Remove build.sql
make master     # Create base script
make import     # Add CSV import commands
make normalize  # Add dimension table creation

# Manual database operations
psql -d enceladus -f build.sql
psql -d enceladus  # Connect to database for queries
```

### Build System

The project uses a Makefile with these targets:

- `make all`: Complete build pipeline (master -> import -> normalize -> execute)
- Build process concatenates SQL scripts into `build.sql` then executes against enceladus database

## Architecture

### Data Flow

1. **Raw Data**: CSV files in `data/` directory (master_plan.csv, jpl_flybys.csv, CDA/, INMS/)
2. **Import Layer**: `import.master_plan` staging table
3. **Dimension Tables**: teams, targets, spass_types, event_types, requests
4. **Fact Table**: `events` table with foreign keys to all dimensions

### Database Schema

- **Star Schema Design**: Central `events` fact table surrounded by dimension tables
- **Timezone Handling**: UTC timestamp conversion with `timestamptz` type
- **Referential Integrity**: Foreign key constraints with cascade deletion
- **Data Types**: Text staging with proper type conversion during normalization

### Data Sources

- `master_plan.csv`: Primary mission planning data (13.1MB, 61,873 rows)
- `jpl_flybys.csv`: Enceladus flyby encounter data
- `CDA/`: Cosmic Dust Analyzer instrument data
- `INMS/`: Ion and Neutral Mass Spectrometer data

## SQL Script Structure

### scripts/import.sql

- Creates `import` schema and staging table
- Defines raw data structure matching CSV format

### scripts/normalize.sql

- Creates dimension tables from distinct values
- Populates fact table with proper relationships
- Handles data type conversions (text to timestamptz)

### build.sql (generated)

- Concatenated script combining import + normalize operations
- Uses absolute paths for CSV file imports
- Complete pipeline from raw data to normalized schema

## Scientific Context

This database contains NASA Cassini mission data (2004-2017) focused on:

- **Mission Instruments**: CAPS, CDA, INMS, ISS, VIMS, UVIS, CIRS, MAG, RPWS
- **Primary Targets**: Saturn, Titan, Enceladus, other moons
- **Mission Types**: SPASS (Science and Power Systems) and Non-SPASS observations
- **Time Scope**: Detailed observation schedules with precise UTC timing

The dimensional model enables efficient analysis of space mission events across multiple facets (time, target, instrument, team, mission type).
