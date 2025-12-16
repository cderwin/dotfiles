const snowobs_token = "71ad26d7aaf410e39efe91bd414d32e1db5d"
const snowobs_base_url = "https://api.snowobs.com/wx/v1/station/data/timeseries/"
const wx_config_path = path self | path parse | get parent | path join "wx_stations.yaml"


def inject-fields [] {
    let patched_stations = $in.STATION | each {
        if "precip_accum_one_hour" in ($in.observations | columns) {
            let cumsum = $in.observations.precip_accum_one_hour | reduce -f [0] {|it, acc| $acc | append (($acc | last) + $it)}
            let patched_observations = $in.observations | insert "precip_cumsum" ($cumsum | skip 1)
            $in | update "observations" $patched_observations
        } else {
            $in
        }
    }

    $in | update STATION $patched_stations
}

export def main [
    station?: string,
    --from (-f): datetime
    --to (-t): datetime
    --raw (-r),
    --list (-l),
] {
    let wx_config = open $wx_config_path
    if $list or $station == null {
        return $wx_config.weather_stations.name
    }

    mut to = $to
    if $to == null {
        $to = date now
    }

    mut from = $from
    if $from == null {
        $from = $to - 1day
    }

    let station_ids = $wx_config.weather_stations | where name == $station | get columns.0.stid | uniq
    let end_date = date now | date to-timezone utc | format date "%Y%m%d%H%M"
    let start_date = $from | date to-timezone utc | format date "%Y%m%d%H%M"
    mut url_data = $snowobs_base_url | url parse
    $url_data.params = {
        source: "nwac",
        token: $snowobs_token,
        stid: ($station_ids | str join ","),
        start_date: $start_date,
        end_date: $end_date,
    }
    $url_data.query = $url_data.params | url build-query
    let wx_data = http get ($url_data | url join) | inject-fields

    if $raw {
        return $wx_data
    }

    let indices = $wx_data.STATION | get observations.date_time.0 | into datetime
    let columns = $wx_config.weather_stations | where name == $station | get columns.0
    $indices | enumerate | each {|idx|
        $columns | each {|column|
            mut key = $wx_config.fields | where api_name == $column.field | get -o display_name.0
                | default ($wx_data.VARIABLES | where variable == $column.field | get -o long_name.0)
                | default $column.field

            # add elevation to field name if duplicate
            let station_data = $wx_data.STATION | where stid == ($column.stid | into string) | get 0
            if ($columns | histogram field | where field == $column.field | get 0.count) > 1 {
                let altitude = $station_data | get elevation | into int
                $key = $"($key) \(($altitude)'\)"
            }

            let val = $station_data
                | get observations
                | get $column.field
                | get -o $idx.index
                | default "-"
            {timestamp: $idx.item, $key: $val}
        } | into record
    } | reverse
}
