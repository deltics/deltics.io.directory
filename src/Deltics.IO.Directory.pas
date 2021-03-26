
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory;


interface

  uses
    Deltics.IO.Directory.Interfaces;


  type
    Directory = class
      class function OfCurrentDir: IDirectory;
      class function OfFolder(const aValue: String): IDirectory;
    end;



implementation

  uses
    SysUtils,
    Deltics.IO.Directory.Implementation_;


{ Directory }

  class function Directory.OfCurrentDir: IDirectory;
  begin
    result := TDirectory.Create(GetCurrentDir);
  end;


  class function Directory.OfFolder(const aValue: String): IDirectory;
  begin
    result := TDirectory.Create(aValue);
  end;



end.
