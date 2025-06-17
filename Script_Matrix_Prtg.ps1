param (
    [string]$device = $args[0],
    [string]$name = $args[1],
    [string]$status = $args[2],
    [string]$parent = $args[3],
    [string]$message = ($args | Select-Object -Skip 4) -join " "
)

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    [Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

    $colorMap = @{
        "down"     = @{ Color="#d32f2f"; Emoji="&#10060;" }
        "warning"  = @{ Color="#f57c00"; Emoji="&#9888;" }
        "up"       = @{ Color="#388e3c"; Emoji="&#9989;" }
        "unknown"  = @{ Color="#616161"; Emoji="&#10067;" }
        "paused"   = @{ Color="#1976d2"; Emoji="&#9208;" }
        "unusual"  = @{ Color="#fbc02d"; Emoji="&#128310;" }
        "default"  = @{ Color="#000000"; Emoji="&#8505;" }
    }

    $statusLower = $status.ToLower()

    $parts = @("Sensor: $name", "Status: $status")
    if ($parent -ne "") { $parts += "Parent: $parent" }
    if ($message -ne "") { $parts += "$message" }
    $plainBody = ($parts -join " | ")

    if ($plainBody -match "(?i)\bup\b") {
        $color = $colorMap["up"].Color
        $icon = $colorMap["up"].Emoji
    }
    elseif ($colorMap.ContainsKey($statusLower)) {
        $color = $colorMap[$statusLower].Color
        $icon = $colorMap[$statusLower].Emoji
    }
    else {
        $color = $colorMap["default"].Color
        $icon = $colorMap["default"].Emoji
    }

    # CHá»– FIX á»ž ÄÃ‚Y - full color all text
    $htmlBody = "<span data-mx-color='$color'><b>$icon $plainBody</b></span>"

    $body = @{
        msgtype = "m.notice"
        body = $plainBody
        format = "org.matrix.custom.html"
        formatted_body = $htmlBody
    } | ConvertTo-Json -Depth 10

    $url = "https://matrix.org/_matrix/client/r0/rooms/!EcakUJjagHEvHkforE:matrix.org/send/m.room.message"
    $token = "mat_jyhzGOXHsWuMMdtLob8KoG5cxGkrNY_hOpQ82"

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
