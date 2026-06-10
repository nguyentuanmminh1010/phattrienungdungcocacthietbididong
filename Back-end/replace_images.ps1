$srcDir = "C:\Users\tminh\.gemini\antigravity-ide\brain\a5ec86b5-b022-415d-b091-04e380227951"
$destDir = "D:\Minh\flutter-projects\testt\assets\images"

$bigBannerSrc = Get-ChildItem -Path $srcDir -Filter "big_banner_*.png" | Select-Object -First 1
$smallBannerSrc = Get-ChildItem -Path $srcDir -Filter "small_banner_*.png" | Select-Object -First 1
$productSrc = Get-ChildItem -Path $srcDir -Filter "product_placeholder_*.png" | Select-Object -First 1
$categorySrc = Get-ChildItem -Path $srcDir -Filter "category_placeholder_*.png" | Select-Object -First 1

# Replace Big Banner and Small Banner
Copy-Item -Path $bigBannerSrc.FullName -Destination (Join-Path $destDir "Big Banner.png") -Force
Copy-Item -Path $smallBannerSrc.FullName -Destination (Join-Path $destDir "Small banner.png") -Force

# Iterate through all other images and replace them
$allImages = Get-ChildItem -Path $destDir -Filter "*.png"
foreach ($img in $allImages) {
    $name = $img.Name
    if ($name -eq "Big Banner.png" -or $name -eq "Small banner.png" -or $name -eq "main.png" -or $name -eq "image.png" -or $name -eq "image (1).png") {
        continue
    }

    if ($name -match "category") {
        Copy-Item -Path $categorySrc.FullName -Destination $img.FullName -Force
    } else {
        Copy-Item -Path $productSrc.FullName -Destination $img.FullName -Force
    }
}
Write-Output "Images successfully replaced."
