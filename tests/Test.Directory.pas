
{$i deltics.inc}

  unit Test.Directory;


interface

  uses
    Deltics.Smoketest;



  type
    DirectoryTests = class(TTest)
      procedure WorksAsExpected;
    end;



implementation

  uses
    Deltics.IO.Directory,
    Deltics.StringLists;



{ Directory }

  procedure DirectoryTests.WorksAsExpected;
  var
    count: Integer;
    files: IStringList;
    ogFiles: IStringList;
    folders: IStringList;
  begin
    count   := -1;
    files   := TStringList.CreateManaged;
    ogFiles := files;

    Directory.OfCurrentDir
      .Yields.Count(count)
      .Yields.Files(files)
      .Yields.Folders(folders)
      .Execute;

    Test('files').Assert(files).IsAssigned;
    Test('files = ogFiles').Assert(files).Equals(ogFiles);
    Test('folders').Assert(folders).IsAssigned;
    Test('count').Assert(count).GreaterThanOrEquals(0);
  end;




end.
