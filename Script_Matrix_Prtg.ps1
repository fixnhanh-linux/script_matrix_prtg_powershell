param (
    [string]$device = $args[0],
    [string]$name = $args[1],
    [string]$status = $args[2],
    [string]$datetime = $args[3],
    [string]$lastvalue = $args[4],
    [string]$lastmessage = $args[5],
    [string]$probe = $args[6],
    [string]$group = $args[7],
    [string]$lastcheck = $args[8],
    [string]$lastup = $args[9],
    [string]$lastdown = $args[10],
    [string]$uptime = $args[11],
    [string]$downtime = $args[12],
    [string]$cumsince = $args[13],
    [string]$location = $args[14],
    [string]$message = ($args | Select-Object -Skip 15) -join " "
)

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    [Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

    $colorMap = @{
        "Down"     = @{ Color="#d32f2f"; Emoji="&#10060;" }
        "Warning"  = @{ Color="#f57c00"; Emoji="&#9888;" }
        "Up"       = @{ Color="#388e3c"; Emoji="&#9989;" }
        "Unknown"  = @{ Color="#616161"; Emoji="&#10067;" }
        "Paused"   = @{ Color="#1976d2"; Emoji="&#9208;" }
        "Unusual"  = @{ Color="#fbc02d"; Emoji="&#128310;" }
        "default"  = @{ Color="#0099FF"; Emoji="&#8505;" }
    }

if ($status -match "down") {
    $color = $colorMap["Down"].Color
    $icon = $colorMap["Down"].Emoji
}
elseif ($colorMap.ContainsKey($status)) {
    $color = $colorMap[$status].Color
    $icon = $colorMap[$status].Emoji
}
else {
    $color = $colorMap["default"].Color
    $icon = $colorMap["default"].Emoji
}


    $plainBody = @"
$icon [$status]
Device: $device
Name: $name
Date/Time: $dateTime (UTC)
Last Result: $lastvalue
Last Message: $lastmessage
Probe: $probe
Group: $group
Last Scan: $lastcheck
Last Up: $lastup
Last Down: $lastdown
Uptime: $uptime
Downtime: $downtime
Cumulated Since: $cumsince
Location: $location
Message: $message
"@

    $htmlBody = @"
<span data-mx-color='$color'>
<strong>$icon [$status]</strong><br />
<b>Device:</b> $device<br />
<b>Name:</b> $name<br />
<b>Date/Time:</b> $datetime<br />
<b>Last Result:</b> $lastvalue<br />
<b>Last Message:</b> $lastmessage<br />
<b>Probe:</b> $probe<br />
<b>Group:</b> $group<br />
<b>Last Scan:</b> $lastcheck<br />
<b>Last Up:</b> $lastup<br />
<b>Last Down:</b> $lastdown<br />
<b>Uptime:</b> $uptime<br />
<b>Downtime:</b> $downtime<br />
<b>Cumulated Since:</b> $cumsince<br />
<b>Location:</b> $location<br />
<b>Message:</b> $message
</span>
"@

    $body = @{
        msgtype = "m.notice"
        body = $plainBody
        format = "org.matrix.custom.html"
        formatted_body = $htmlBody
    } | ConvertTo-Json -Depth 10

    $url = "https://team.fixnhanh.cloud/_matrix/client/r0/rooms/!vQdUVTmHCrCpJjWxwR:fixnhanh.cloud/send/m.room.message"
    $token = "syt_MjAuMTM0OTU4LjE0MDM_WaktNVSQFUvllslHnaaj_1iHiE5"

    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }

    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ErrorAction Stop
}
catch {
    Write-Output "Error: $_"
    exit 1
}
