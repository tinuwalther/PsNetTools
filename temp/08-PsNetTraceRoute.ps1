$destination = 'sbb.ch'

$pingsender  = [System.Net.NetworkInformation.Ping]::new()
$pingoptions.DontFragment = $true

[int] $timeout    = 10000
[int] $maxTTL     = 30

$dgram = new-object System.Text.ASCIIEncoding
$byte  = $dgram.GetBytes("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

for($ttl = 1; $ttl -lt $maxTTL; $ttl ++){
    $pingoptions = [System.Net.NetworkInformation.PingOptions]::new($ttl, $true)

    $reply = $pingsender.Send($destination, $timeout, $byte, $pingoptions)

    $reply 
}
