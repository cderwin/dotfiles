const a3url = "https://api.avalanche.org/v2/public/product?type=forecast&center_id=NWAC&zone_id=1647"
const forecast_zones = {
    "east-south": 1656,
    "east-central": 1655,
    "east-north": 1654,
    "west-south": 1648,
    "west-central": 1647,
    "west-north": 1646,
    "snoqualmie": 1653,
    "stevens": 1649,
    "hood": 1657,
    "olympics": 1645,
}

def unescape-html [] {
    query web -q "p" | flatten | str join "\n\n"
}

def parse-problems [] {
    get forecast_avalanche_problems
        | select rank name likelihood size location discussion
        | update location {  parse "{cardinal} {band}" }
        | update discussion { unescape-html }
        | update size { {min: $in.0, max: $in.1} }
        | rename -c {location: rose}
        | sort-by rank
}

export def main [
    zone?: string,
    --list (-l),
    --raw (-r),
] {
    if $list or $zone == null {
        return ($forecast_zones | columns)
    }

    if not ($zone in $forecast_zones) {
        print $"(ansi red)zone \"($zone)\" is not a valid forecast zone(ansi reset)"
        return ($forecast_zones | columns)
    }

    mut url_data = $a3url | url parse
    $url_data.params = {
        type: "forecast",
        center_id: "NWAC",
        zone_id: ($forecast_zones | get $zone)
    }
    $url_data.query = $url_data.params | url build-query
    let fx_data = http get ($url_data | url join)

    if $raw {
        return $fx_data
    }

    let danger = $fx_data | get danger | where valid_day == current | select upper middle lower | into record
    let danger_tomorrow = $fx_data | get danger | where valid_day == tomorrow | select upper middle lower | into record
    {
        zone: $fx_data.forecast_zone.name,
        link: $fx_data.forecast_zone.url,
        author: $fx_data.author,
        expires_at: ($fx_data.expires_time | into datetime),
        danger: $danger,
        danger_tomorrow: $danger_tomorrow,
        bottom_line: ($fx_data.bottom_line | unescape-html),
        discussion: ($fx_data.hazard_discussion | unescape-html),
        problems: ($fx_data | parse-problems),
    }
}
