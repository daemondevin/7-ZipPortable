
# 7-Zip Portable

7-ZipPortable is a portable version of the popular [7-Zip][C1] application. 7-Zip is a file archiver with a high compression ratio.

The main features of 7-Zip:

* High compression ratio in 7z format with LZMA and LZMA2 compression
* Supported formats:
* Packing / unpacking: 7z, XZ, BZIP2, GZIP, TAR, ZIP and WIM
* Unpacking only: AR, ARJ, CAB, CHM, CPIO, CramFS, DMG, EXT, FAT, GPT, HFS, IHEX, ISO, LZH, LZMA, MBR, MSI, NSIS, NTFS, QCOW2, RAR, RPM, SquashFS, UDF, UEFI, VDI, VHD, VMDK, WIM, XAR and Z.
* For ZIP and GZIP formats, 7-Zip provides a compression ratio that is 2-10 % better than the ratio provided by PKZip and WinZip
* Strong AES-256 encryption in 7z and ZIP formats
* Self-extracting capability for 7z format
* Integration with Windows Shell
* Powerful File Manager
* Powerful command line version
* Plugin for FAR Manager
* Localizations for 87 languages

Visit the [7-Zip Homepage](http://7-zip.org/).

## Support

To recompile this PAF you must use my version of the [PortableApps.com Launcher][S1].

 [S1]: https://github.com/demondevin/portableapps.comlauncher

## Download

All downloads available in the [Releases section][D1]. This portable application was packaged using a modified version of the [PortableApps.com][D2] Launcher.

 [D1]: https://github.com/demondevin/7-ZipPortable/releases/latest
 [D2]: http//portableapps.com/

## Features

* Runs the full 7-Zip file/archive manager.
* Completely portable - runs off a USB, cloud drive (DropBox, iCloud drive,
  OneDrive, etc) or hard drive.
* No need for any external software - simply download extract and run!
* Packaged in PortableApps.com format for easy integration.
* Associations are supported and easily customizable.
> To add your own file associations, open the `7-ZipPortable.ini` file. Under `[Associations]` add any extension you wish to support. For example:
> ```INI
> [Associations]
> 1=7z
> 2=001
> 3=rar
> 4=zip
> ```
> For a list of all supported filetypes, open `AppInfo.ini` and review the `[Associations]Filetypes` key. 
> 
> **Note**:
> - Adding a lot of extensions can and will effect launch time. 
> - Windows XP tends to cache icon resources which are inevitably visible even after exiting 7-Zip.
> - Windows 8 can be problematic and may require unlocking for some filetypes&mdash;_i.e._ when double-clicking on a supported file format and Windows asks you to select 7-Zip from a list. This is because Windows 8 has an implementation of a hash ID for associations. 
> - Do not associate through 7-Zip! This will leave trash in the registry when you exit the program. 
* SendTo is also available for any filetypes that aren't associated but are supported for use with 7-Zip.
* Added ability to use shell extension/context menu features. See user configuration file to enable. Do not enable this feature through 7-Zip!
* The user configuration file includes the following optional settings:
> ```INI
> [7-ZipPortable]
> AdditionalParameters=
> ShellExtension=true
> RunLocally=false
> USBDevice=false
> Banner=false
> ```
> - AdditionalParameters: Pass additional command-line switches.
> - ShellExtension: (`true`, `false`, `auto`) Enable/disable Shell Extension/Context Menu features. Requires administrative rights.
> - RunLocally: (`true`/`false`) Application is copied to and executed from `%TEMP%` directory.
> - USBDevice: (`true`/`false`) Enable to prevent ejection/unplugging problems with removable devices. When `ShellExtension` is enabled, Windows Explorer tends to lock application's DLL(s). If enabled, PAF will ensure DLL(s) are unlocked.
> - Banner: (`true`/`false`) Enable/disable initialization banner.
* More features soon to come!

## System Requirements

* Microsoft Windows XP or later.
* [PortableApps.com Platform][R1] (Optional)

 [R1]: http://portableapps.com/download

## Credits

* FukenGruven was the original developer of this portable release.
* I have added support to compile with my [launcher][S1] and maintain it.
* 7-Zip Portable is a redistribution of the
  [7-Zip][C1] archive manager developed by [Igor Pavlov][C2].
* [PortableApps.com Suite][R1] by [PortableApps.com][D2].
* [PortableApps.com Launcher][S1] developed by [demon.devin][C3].

 [C1]: http://7-zip.org/
 [C2]: https://en.wikipedia.org/wiki/Igor_Pavlov_(programmer)
 [C3]: https://github.com/demondevin

## License

* Portable application code released under [the MIT license][L1].
* 7-Zip is governed under the [GNU LGPL][L2] License.

 [L1]: https://raw.githubusercontent.com/demondevin/7-ZipPortable/master/LICENSE
 [L2]: http://7-zip.org/license.txt
 
