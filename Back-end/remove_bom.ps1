$files = Get-ChildItem -Path "D:\Minh\java-project\test\src\main\java\com\nguyentuanminh\test\entity\*.java"
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}
Write-Host "BOM removed from all java files."
