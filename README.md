# PowershellPodcatcher
A simple powershell script for downloading podcasts

Written and tested on Windows 10 using Powershell 5.1.  You may have mixed results on other platform/version combinations, but that's why this is open source - so you can take it and adapt it to your needs. 

## Usage

First you must obtain the RSS feed URL.  The easiest way to do this is via https://podcastaddict.com/

Then you should create a folder to pass into the script.  Once you have that, usage is just like:

`.\DownloadPodcast.ps1 -uri https://feeds.megaphone.fm/darknessprevails -outputfolder F:\Podcasts\UnexplainedEncounters`

For folders with spaces in the name, use syntax like:

`.\DownloadPodcast.ps1 -uri https://feeds.megaphone.fm/darknessprevails -outputfolder "F:\Podcasts\Unexplained Encounters"`

## Download resume

Be aware that there's very little resume functionality in the script.  Basically:  If the file it is about to download already exists, it'll skip it.

If you had a transfer interrupted, just delete any partial file(s) and run it again.

The nice thing about this design is that you can create a scheduled task to get new podcast episodes.

## Retry

A failed file download will just skip that file and continue on.  Pay attention!

## Debugging

Setting `$DebugPreference = 'Continue'` in your powershell session will execute the script in debug mode.  Some extra details will be emitted, and audio files will not be downloaded (just empty files with the same names will be created on disk).

To undo debug mode, just set the preference back to `$DebugPreference = 'SilentlyContinue'`
