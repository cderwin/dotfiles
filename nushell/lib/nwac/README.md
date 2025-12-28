# NWAC Weather & Avalanche Forecast Tools

A Nushell library for accessing Northwest Avalanche Center (NWAC) weather station data, mountain weather forecasts, and avalanche forecasts directly from the command line.

## Commands Overview

- `nwac wx` - Get current weather station data
- `nwac fx` - Get mountain weather forecasts
- `nwac ax` - Get avalanche forecasts

## Installation

Add the NWAC module to your Nushell environment:

```nushell
use /path/to/nwac
```

## `nwac wx` - Weather Station Data

Get recent weather observations from NWAC weather stations across the Pacific Northwest.

### Usage

```nushell
nwac wx [station] [options]
```

### Options

- `--list, -l` - List all available weather stations
- `--from, -f <datetime>` - Start date/time for data (default: 24 hours ago)
- `--to, -t <datetime>` - End date/time for data (default: now)
- `--raw, -r` - Return raw API response data

### Available Stations

```
alpental, berne, blewett-pass, muir, chinook-pass, crystal-base, crystal,
dirtyface, hurricane-ridge, lake-wenatchee, mazama, mission-ridge, baker,
hood-meadows, hood-meadows-cascade, mt-washington, st-helens, newhalem,
paradise, hood-timberline, hood-timberline-magicmile, tumwater, hood-skibowl,
snoqualmie, stevens-schmidthaus, stevens-brooks, stevens-grace-lakes,
stevens-skyline, sunrise, washington-pass, whitechuck, white-pass
```

### Examples

List all available weather stations:
```nushell
nwac wx --list
```

Get the latest 24 hours of weather data from Paradise:
```nushell
nwac wx paradise
```

Get weather data for a specific time range:
```nushell
nwac wx paradise --from (date now | date -2day) --to (date now)
```

Get the last 5 observations from a station:
```nushell
nwac wx crystal | first 5
```

### Sample Output

```
╭───┬─────────────┬──────┬────┬─────┬─────┬──────┬─────┬──────┬────────╮
│ # │  timestamp  │ Temp │ RH │ Min │ Spd │ Gust │ Dir │ Pcp1 │ PcpSum │
├───┼─────────────┼──────┼────┼─────┼─────┼──────┼─────┼──────┼────────┤
│ 0 │ an hour ago │   15 │ 93 │   0 │   1 │    4 │  16 │ 0.00 │   0.05 │
│ 1 │ 2 hours ago │   16 │ 93 │   0 │   0 │    3 │ 280 │ 0.00 │   0.05 │
│ 2 │ 2 hours ago │   18 │ 95 │   0 │   0 │    1 │ 278 │ 0.01 │   0.05 │
│ 3 │ 3 hours ago │   18 │ 95 │   0 │   0 │    1 │ 277 │ 0.00 │   0.04 │
│ 4 │ 4 hours ago │   18 │ 95 │   0 │   1 │    3 │ 277 │ 0.00 │   0.04 │
╰───┴─────────────┴──────┴────┴─────┴─────┴──────┴─────┴──────┴────────╯
```

### Field Descriptions

- **Temp** - Temperature (°F)
- **RH** - Relative Humidity (%)
- **Min** - Minimum temperature (°F)
- **Spd** - Wind speed (mph)
- **Gust** - Wind gust (mph)
- **Dir** - Wind direction (degrees)
- **Pcp1** - 1-hour precipitation accumulation (inches)
- **PcpSum** - Cumulative precipitation (inches)

## `nwac fx` - Mountain Weather Forecast

Get the current mountain weather forecast from NWAC, including precipitation, snow levels, temperatures, and wind conditions.

### Usage

```nushell
nwac fx [options]
```

### Options

- `--raw, -r` - Return raw HTML response

### Examples

Get the current mountain weather forecast:
```nushell
nwac fx
```

View the forecast synopsis:
```nushell
nwac fx | get synopsis
```

View precipitation forecast by region:
```nushell
nwac fx | get precip
```

View snow levels:
```nushell
nwac fx | get snow_level
```

View temperatures at 5000 feet:
```nushell
nwac fx | get 5000_temp
```

View wind forecast:
```nushell
nwac fx | get wind
```

### Sample Output Structure

The forecast returns a structured record with the following fields:

- **synopsis** - Overall weather synopsis and discussion
- **precip** - Precipitation forecast table by region and time period
- **snow_level** - Snow level forecast by region and time period
- **5000_temp** - Temperature forecast at 5000' elevation
- **wind** - Wind forecast at 5000' elevation
- **extended_synopsis** - Extended outlook discussion
- **extended_snow_level** - Extended snow level forecast

### Example: Viewing Snow Levels

```nushell
nwac fx | get snow_level | where Region == "West Central"
```

```
╭────────┬──────────────┬──────────────────┬────────────────┬─────────────────────┬─────────────────╮
│ Region │ Sat Evening  │ Saturday Night   │ Sunday Morning │ Sunday Afternoon    │ Sunday Evening  │
├────────┼──────────────┼──────────────────┼────────────────┼─────────────────────┼─────────────────┤
│ West   │ 1000'        │ 1000'            │ 1500'          │ 3500'               │ 4500'           │
│ Central│              │                  │                │                     │                 │
╰────────┴──────────────┴──────────────────┴────────────────┴─────────────────────┴─────────────────╯
```

## `nwac ax` - Avalanche Forecast

Get avalanche forecasts for specific zones in the Pacific Northwest.

### Usage

```nushell
nwac ax [zone] [options]
```

### Options

- `--list, -l` - List all available forecast zones
- `--raw, -r` - Return raw API response data

### Available Zones

```
east-south, east-central, east-north, west-south, west-central, west-north,
snoqualmie, stevens, hood, olympics
```

### Examples

List all available avalanche forecast zones:
```nushell
nwac ax --list
```

Get the avalanche forecast for West Central:
```nushell
nwac ax west-central
```

View just the danger ratings:
```nushell
nwac ax west-central | get danger
```

View the bottom line summary:
```nushell
nwac ax west-central | get bottom_line
```

View avalanche problems:
```nushell
nwac ax west-central | get problems
```

### Sample Output Structure

The avalanche forecast returns a structured record with:

- **zone** - Forecast zone name
- **link** - URL to full forecast
- **author** - Forecaster name
- **expires_at** - When the forecast expires
- **danger** - Current day danger ratings (upper/middle/lower elevations)
- **danger_tomorrow** - Tomorrow's danger ratings
- **bottom_line** - Brief summary of avalanche conditions
- **discussion** - Detailed hazard discussion
- **problems** - List of avalanche problems with details

### Example: Current Danger Ratings

```nushell
nwac ax west-central | get danger
```

```
╭────────┬───╮
│ upper  │ 2 │
│ middle │ 2 │
│ lower  │ 1 │
╰────────┴───╯
```

### Example: Avalanche Problems

```nushell
nwac ax west-central | get problems
```

```
╭───┬──────┬────────────┬────────────┬──────┬──────────────┬──────────────────────────╮
│ # │ rank │    name    │ likelihood │ size │     rose     │       discussion         │
├───┼──────┼────────────┼────────────┼──────┼──────────────┼──────────────────────────┤
│ 0 │    1 │ Wind Slab  │ possible   │ min: │ [table: 16   │ With another day to      │
│   │      │            │            │ 1    │ rows]        │ bond, triggering a wind  │
│   │      │            │            │ max: │              │ slab will generally...   │
│   │      │            │            │ 2    │              │                          │
│ 1 │    2 │ Wet Loose  │ possible   │ min: │ [table: 9    │ A bit more sun and       │
│   │      │            │            │ 1    │ rows]        │ plenty of soft snow...   │
│   │      │            │            │ max: │              │                          │
│   │      │            │            │ 1.5  │              │                          │
╰───┴──────┴────────────┴────────────┴──────┴──────────────┴──────────────────────────╯
```

### Danger Rating Scale

- **1** - Low
- **2** - Moderate
- **3** - Considerable
- **4** - High
- **5** - Extreme

### Avalanche Size Scale

- **1** - Small (relatively harmless to people)
- **1.5** - Small to Large
- **2** - Large (could bury, injure, or kill a person)
- **2.5** - Large to Very Large
- **3** - Very Large (could bury and destroy a car)
- **4** - Historic (larger than typically seen)

## Tips & Tricks

### Combining Commands

Monitor conditions at your favorite zone:
```nushell
# Get weather and avalanche forecast for Snoqualmie
nwac wx snoqualmie | first 10
nwac ax snoqualmie
```

### Data Export

Export forecast data to JSON:
```nushell
nwac fx | to json | save forecast.json
```

Export weather data to CSV:
```nushell
nwac wx paradise | to csv | save paradise-weather.csv
```

### Filtering & Analysis

Find hours with significant precipitation:
```nushell
nwac wx paradise | where Pcp1 > 0.1
```

Get average temperature over the period:
```nushell
nwac wx crystal | get Temp | math avg
```

Compare conditions across multiple stations:
```nushell
['paradise', 'crystal', 'snoqualmie'] | each {|station|
    nwac wx $station | first 1 | insert station $station
}
```

### Custom Time Ranges

Get weather for a specific storm event:
```nushell
nwac wx baker --from "2025-01-15 00:00" --to "2025-01-16 12:00"
```

## Data Sources

- Weather station data: [SnowObs API](https://api.snowobs.com)
- Mountain weather forecasts: [NWAC Mountain Weather](https://nwac.us/mountain-weather-forecast/)
- Avalanche forecasts: [Avalanche.org API](https://api.avalanche.org)

## Notes

- Weather data is typically updated hourly
- Avalanche forecasts are updated daily, usually by early morning
- Mountain weather forecasts are updated twice daily
- Some weather stations may have limited data availability during outages
- Time ranges use Nushell datetime format

## Resources

- [Northwest Avalanche Center](https://nwac.us)
- [NWAC Weather Stations Map](https://nwac.us/weather-data/)
- [Avalanche Safety Education](https://nwac.us/education/)
