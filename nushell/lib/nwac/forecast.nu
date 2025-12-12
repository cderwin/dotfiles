const forecast_url = "https://nwac.us/mountain-weather-forecast/"

export def fx [
    --raw (-r),
] {
    let html = http get $forecast_url

    if $raw {
        return $html
    }

    let synopsis = $html | query web -q div.synopsis | get 0 | str trim | compact -e | skip 1
    {
        synopsis: $synopsis
    }
}
