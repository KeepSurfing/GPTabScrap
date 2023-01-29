$base_url = "https://gtptabs.com/tabs/download/"
$Directory = "./tablatures"
$ret = 200
$index = 1

do {
	$uri = -join($base_url, $index, ".html")
	$WebResponse = Invoke-WebRequest $uri
	$ret = $WebResponse.StatusCode
	
	$content = [System.Net.Mime.ContentDisposition]::new($WebResponse.Headers["Content-Disposition"])
	$fileName = $content.FileName

	if (!$fileName) {
		$fileName = -join("name_not_found_", $index, ".gp3")
	}

	$fullPath = Join-Path -Path $Directory -ChildPath $fileName

	$file = [System.IO.FileStream]::new($fullPath, [System.IO.FileMode]::Create)
	$file.Write($WebResponse.Content, 0, $WebResponse.RawContentLength)
	$file.Close()
	if (($index % 100) -eq 0) {
		Write-Output "Downloaded $index tabs"
	}
	
	$index++
} while ($ret -eq 200)