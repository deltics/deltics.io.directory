
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory.Interfaces;


interface

  uses
    Deltics.StringLists;


  type
    IDirectoryBuilder = interface;
    IDirectoryYields = interface;



    IDirectoryBuilder = interface
    ['{6D72FE75-B581-4BD4-A406-7E356BFA7EC3}']
      function Filename(const aValue: String): IDirectoryBuilder;
      function Recursive: IDirectoryBuilder; overload;
      function Recursive(const aValue: Boolean): IDirectoryBuilder; overload;
      function Yields: IDirectoryYields;
      function Execute: Boolean;
    end;


    IDirectoryYields = interface
    ['{CB4ECE16-77CB-4B6F-B323-59E303083F5D}']
      function Count(var aCount: Integer): IDirectorybuilder;
      function Files(var aList: IStringList): IDirectorybuilder;
      function Folders(var aList: IStringList): IDirectorybuilder;
    end;


implementation

end.
