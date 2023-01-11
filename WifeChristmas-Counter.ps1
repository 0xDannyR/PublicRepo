<#
.Description
Count down the days until christmas
.Notes
Need to expand to include weather information
#>

#   credentials to send the message
$telegramToken = "REMOVED"
$chatID = REMOVED

#   simple math to get days until christmas
$currentDay = (Get-Date).Day
$daysUntilChristmas = 25 - $currentDay

#   messages should cycle through array choosing random word for the daily message.
$wordArray = @('Cutie', 'Good-looking', 'Gorgeous', 'Love', 'Angel', 'Amor', 'Hermosa', 'Baby', 'Babycakes', 'Reina')
$randomWord = Get-Random -InputObject $wordArray

#   current weather from weather underground
$currentWeatherResponse = Invoke-RestMethod -Uri 'http://api.openweathermap.org/data/2.5/weather?id=4499379&appid=d0c14a8bb562016a67a042a2f5a8527d'

$weatherDescription = $currentWeatherResponse.weather.description

#   weather needs to be converted from Kelvin to Farenheit
$currentTemp = ($currentWeatherResponse.main.temp - 273.15) * 1.8 + 32
$feelsLikeTemp = ($currentWeatherResponse.main.feels_like - 273.15) * 1.8 + 32
$minTemp = ($currentWeatherResponse.main.temp_min - 273.15) * 1.8 + 32
$maxTemp = ($currentWeatherResponse.main.temp_max - 273.15) * 1.8 + 32


$message = "Good morning $randomWord <3`nCurrently it's $currentTemp degrees and $weatherDescription but it feels like $feelsLikeTemp.Today's lowest will be $minTemp while the highest will be $maxTemp. AND THERE ARE ONLY $daysUntilChristmas DAYS UNTIL CHRISTMAS!"


$execute = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($telegramToken)/sendmessage?chat_id=$($chatID)&text=$($message)"