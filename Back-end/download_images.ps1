$destDir = "D:\Minh\flutter-projects\testt\assets\images"
$allImages = Get-ChildItem -Path $destDir -Filter "*.png"

$i = 1
foreach ($img in $allImages) {
    $name = $img.Name.ToLower()
    
    # Skip UI banners and main images
    if ($name -match "main.png" -or $name -match "image.png" -or $name -match "image \(1\).png" -or $name -match "big banner" -or $name -match "small banner") {
        continue
    }

    $url = "https://loremflickr.com/400/500/fashion?lock=$i"
    Write-Output "Downloading for $($img.Name)..."
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $img.FullName -UseBasicParsing
    } catch {
        Write-Output "Failed to download $url, using fallback picsum"
        $fallbackUrl = "https://picsum.photos/seed/$i/400/500"
        Invoke-WebRequest -Uri $fallbackUrl -OutFile $img.FullName -UseBasicParsing
    }
    
    $i++
}

Write-Output "Successfully downloaded $i unique images."
