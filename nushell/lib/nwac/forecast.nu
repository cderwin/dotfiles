const forecast_url = "https://nwac.us/mountain-weather-forecast/"

def parse-table [
    selector: string,
    --table-index (-t): int = 0,
    --subheader (-s),
] {
    let table_data = $in | query web --query $"($selector).desktop table" -m | get -o $table_index | default "" | query web --query "tr" | each { str trim | compact -e }
    if ($table_data | length) < 1 {
        return null
    }

    let header = $table_data | first | str replace --regex '[\s\n]+' " " | prepend Region
    $table_data | skip 1
        | update 0 { if $subheader { $in | prepend [null] } else { $in } }
        | each {|r| $header | zip $r | into record }
}

export def main [
    --raw (-r),
] {
    let html = http get $forecast_url

    if $raw {
        return $html
    }

    let synopsis = $html | query web -q "div.synopsis p" | flatten | str join "\n\n"
    let extended_synopsis = $html | query web -q "div.extended-synopsis p" | get -o 0 | default [] | str trim
    {
        synopsis: $synopsis,
        summary: "",
        precip: ($html | parse-table ".precipitation" -s),
        snow_level: ($html | parse-table ".snow-level"),
        5000_temp: ($html | parse-table ".temperatures" -s),
        wind: ($html | parse-table "h4#free-winds-5k ~ "),
        extended_synopsis: $extended_synopsis,
        extended_snow_level: ($html | parse-table ".snow-level" -t 1),
    }
}
