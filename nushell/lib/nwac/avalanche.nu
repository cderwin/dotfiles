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

const character_table = {
    "nbsp": " ",
    "lt": "<",
    "gt": ">",
    "amp": "&",
    "quote": "\"",
    "apos": "'",
    "cent": "¢",
    "pound": "£",
    "yen": "¥",
    "euro": "€",
    "copy": "©",
    "reg": "®",
    "trade": "™",
}

def unescape-html [] : [string: string] {
    $character_table 
        | items {|key, val| [key, val]}
        | reduce -f $in { |item, blob|
            $blob | str replace $"&($item.0);" $item.1
        }
}

export def avy [
    zone?: string,
    --list (-l),
    --raw (-r),
] {
    if $list or $zone == null {
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

    {
        zone: $fx_data.forecast_zone.name,
        link: $fx_data.forecast_zone.url,
        author: $fx_data.author,
        expires_at: ($fx_data.expires_time | into datetime),
        danger: {},
        danger_tomorrow: {},
        bottom_line: ($fx_data.bottom_line | unescape-html),
        discussion: ($fx_data.hazard_discussion | unescape-html),
        problems: {},
    }
}
