param ([string]$uri, [string]$outputfolder)

if(test-path -Path "$($env:TEMP)\tempfile.xml")
{
    remove-item -LiteralPath "$($env:TEMP)\tempfile.xml"
}

invoke-webrequest -uri $uri -OutFile "$($env:TEMP)\tempfile.xml"

$xmlfile = [xml](get-content "$($env:TEMP)\tempfile.xml")


foreach($item in Select-Xml -Xml $xmlfile -XPath "/rss/channel/item")
{
    $filepath = "$outputfolder\$($item.node.title).mp3".replace("|","-")
    invoke-webrequest -uri $item.Node.enclosure.url -outfile $filepath
}