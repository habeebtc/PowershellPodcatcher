param ([string]$uri, [string]$outputfolder)

function normalizeFilename([string]$filename)
{
    $filename = $filename.Replace("|","-")
    $filename = $filename.Replace("`"","'")
    $filename = $filename.Replace("\","-")
    $filename = $filename.Replace("/","-")
    $filename = $filename.Replace(":","-")
    $filename = $filename.Replace(">","}")
    $filename = $filename.Replace("<","{")
    $filename = $filename.Replace
	#This is the pattern for trimming out unwanted Unicode chars on powershell 5.1
	$filename = $filename.Replace([char]0x00A0," ")
	$filename = $filename.Replace("?"," ")
	
    return $filename
}

if(test-path -Path "$($env:TEMP)\tempfile.xml")
{
    remove-item -LiteralPath "$($env:TEMP)\tempfile.xml"
}

invoke-webrequest -uri $uri -OutFile "$($env:TEMP)\tempfile.xml"
$xmlfile = [xml](get-content "$($env:TEMP)\tempfile.xml" -encoding utf8)

try
{
    foreach($item in Select-Xml -Xml $xmlfile -XPath "/rss/channel/item")
    {
        #get file extension
		$len = ($item.Node.enclosure.url.split("?")[0]).length
		$ext = $item.Node.enclosure.url.split("?")[0].substring($len - 3,3)
        if($item.node.title.count -gt 1)
        {
			write-debug "title count greater than 1"
			$titlenode = $item.node.title[0]
        }
        else
        {
			write-debug "title count not greater than 1"
			$titlenode = $item.node.title
        }
		
		if($titlenode.innertext -ne $null)
		{
			write-debug "Inner text is $($titlenode.innertext)"
			$filepath = "$outputfolder\$(normalizeFilename($titlenode.innertext)).$ext"
		}
		else
		{
			write-debug "Node title is $($titlenode)"
			$filepath = "$outputfolder\$(normalizeFilename($titlenode)).$ext"
		}

        if($false -eq (test-path $filepath -IsValid))  
        {
            write-output "path invalid!"
			$filepath
        }
        else
        {
            #simplest possible download management: don't download if file exists
            if($false -eq (test-path $filepath))
            {
                invoke-webrequest -uri $item.Node.enclosure.url -outfile $filepath
            }
        }
    }
}
catch
{
    Write-Output $_
     "filepath: $filepath"
}
