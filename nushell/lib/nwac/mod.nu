export module ./avalanche.nu
export module ./forecast.nu
export module ./weather.nu

export def main [] {
    help main
}

use ./avalanche.nu
use ./forecast.nu
use ./weather.nu

export alias fx = forecast
export alias wx = weather
export alias ax = avalanche
