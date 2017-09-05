for /r %%X in (*) do "E:\PortableApps\7-ZipPortable\App\7-Zip64\7z.exe" a -t7z -mx9 -mmt -ms=on "%%X.7z" "%%X\"

rem NOTE: Edit location of 7z.exe to reflect your setup.
rem This will compress all files in a given directory.
rem Simply copy & paste into directory where files are located, then execute.
rem Similar to WinRAR's "Put each file into separate archives".

rem SFX archives: 
rem edit -t7z to -sfx
rem edit "%%X.7z" to "%%X.exe"

rem Other formats:
rem -t7z    | archive.7z
rem -tgzip  | archive.gzip, archive.gz
rem -tzip   | archive.zip
rem -tbzip2 | archive.bzip2
rem -ttar   | tarball.tar
rem -tiso   | image.iso
rem -tudf   | disk.udf
