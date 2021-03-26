
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory.Interfaces;


interface

  uses
    Deltics.StringLists;


  type
    IDirectory = interface;
    IDirectoryYields = interface;



    IDirectory = interface
    ['{6D72FE75-B581-4BD4-A406-7E356BFA7EC3}']
      function Filename(const aValue: String): IDirectory;
      function Recursive: IDirectory; overload;
      function Recursive(const aValue: Boolean): IDirectory; overload;
      function Yielding: IDirectoryYields;
      function Execute: Boolean;
    end;


    IDirectoryYields = interface
    ['{CB4ECE16-77CB-4B6F-B323-59E303083F5D}']
      function Count(var aCount: Integer): IDirectory;
      function Files(var aList: IStringList): IDirectory;
      function Folders(var aList: IStringList): IDirectory;
    end;


implementation

end.
