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
    return $filename
}

if(test-path -Path "$($env:TEMP)\tempfile.xml")
{
    remove-item -LiteralPath "$($env:TEMP)\tempfile.xml"
}

invoke-webrequest -uri $uri -OutFile "$($env:TEMP)\tempfile.xml"

$xmlfile = [xml](get-content "$($env:TEMP)\tempfile.xml")

$namespaces = @{itunes = "http://www.itunes.com/dtds/podcast-1.0.dtd"}

try
{
    foreach($item in Select-Xml -Xml $xmlfile -XPath "/rss/channel/item")
    {
        #The below check deals with the apple store namespace which if populated puts 2 title records in the xpath results
        if($item.node.title.count -gt 1)
        {
            $filepath = "$outputfolder\$(normalizeFilename($item.node.title[0])).mp3"
        }
        else
        {
            $filepath = "$outputfolder\$(normalizeFilename($item.node.title)).mp3"
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
