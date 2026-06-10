$srcDir = "C:\Users\tminh\.gemini\antigravity-ide\brain\a5ec86b5-b022-415d-b091-04e380227951"
$destDir = "D:\Minh\flutter-projects\testt\assets\images"

# Get available images
$dressImg = Get-ChildItem -Path $srcDir -Filter "gen_dress_*.png" | Select-Object -First 1
$shirtImg = Get-ChildItem -Path $srcDir -Filter "gen_shirt_*.png" | Select-Object -First 1
$productImg = Get-ChildItem -Path $srcDir -Filter "product_placeholder_*.png" | Select-Object -First 1
$categoryImg = Get-ChildItem -Path $srcDir -Filter "category_placeholder_*.png" | Select-Object -First 1

$allImages = Get-ChildItem -Path $destDir -Filter "*.png"

foreach ($img in $allImages) {
    $name = $img.Name.ToLower()
    
    # Skip standard UI banners/icons if they exist
    if ($name -match "main.png" -or $name -match "image.png" -or $name -match "image \(1\).png" -or $name -match "big banner" -or $name -match "small banner") {
        continue
    }

    $targetImg = $productImg # Default for products

    if ($name -match "category") {
        $targetImg = $categoryImg
    }
    elseif ($name -match "dress" -or $name -match "skirt") {
        $targetImg = $dressImg
    }
    elseif ($name -match "shirt" -or $name -match "top" -or $name -match "blouse" -or $name -match "tshirt") {
        $targetImg = $shirtImg
    }

    Copy-Item -Path $targetImg.FullName -Destination $img.FullName -Force
}

Write-Output "Image mapping completed with available generated images."
