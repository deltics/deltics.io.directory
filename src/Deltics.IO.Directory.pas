
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory;


interface

  uses
    Deltics.IO.Directory.Interfaces;


  type
    Directory = class
      class function OfCurrentDir: IDirectoryBuilder;
      class function OfFolder(const aValue: String): IDirectoryBuilder;
    end;



implementation

  uses
    SysUtils,
    Deltics.IO.Directory.Builder;


{ Directory }

  class function Directory.OfCurrentDir: IDirectoryBuilder;
  begin
    result := TDirectoryBuilder.Create(GetCurrentDir);
  end;


  class function Directory.OfFolder(const aValue: String): IDirectoryBuilder;
  begin
    result := TDirectoryBuilder.Create(aValue);
  end;



end.
