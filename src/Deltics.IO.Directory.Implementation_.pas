
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory.Implementation_;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.StringLists,
    Deltics.IO.Directory.Interfaces;


  type
    PStringList = ^IStringList;


    TDirectory = class(TComInterfacedObject, IDirectory,
                                             IDirectoryYields)
    public // IDirectoryBuilder
      function Filename(const aValue: String): IDirectory;
      function Recursive: IDirectory; overload;
      function Recursive(const aValue: Boolean): IDirectory; overload;
      function Yielding: IDirectoryYields;
      function Execute: Boolean;
    public // IDirectoryYields
      function Count(var aCount: Integer): IDirectory;
      function Files(var aList: IStringList): IDirectory;
      function Folders(var aList: IStringList): IDirectory;

    private
      // Inputs
      fFilenames: StringArray;
      fFolder: String;
      fRecursive: Boolean;

      // Outputs
      fCountDest: PInteger;
      fFilesDest: PStringList;
      fFoldersDest: PStringList;
    public
      constructor Create(const aFolder: String);
    end;




implementation

  uses
    SysUtils,
    Deltics.IO.Path;



  type
    TFilePathFn = function(const aPath: String; const aFilename: String): String;


  function NonRecursiveFilePath(const aPath: String; const aFilename: String): String;
  begin
    result := aFilename;
  end;


  function RecursiveFilePath(const aPath: String; const aFilename: String): String;
  begin
    result := Path.Append(aPath, aFilename);
  end;



{ TDirectoryBuilder }

  constructor TDirectory.Create(const aFolder: String);
  begin
    inherited Create;

    fFolder := aFolder;
  end;


  function TDirectory.Execute: Boolean;
  var
    count: Integer;
    files: IStringList;
    folders: IStringList;
    FilePath: TFilePathFn;

    procedure Find(const aPath: String; const aPattern: String);
    var
      i: Integer;
      rec: TSearchRec;
      subfolders: IStringList;
    begin
      subfolders := TStringList.CreateManaged;
      if FindFirst(aPath + '\' + aPattern, faAnyFile, rec) = 0 then
      try
        repeat
          if (rec.Name = '.') or (rec.Name = '..') then
            CONTINUE;

          if ((rec.Attr and faDirectory) <> 0) then
          begin
            if Assigned(folders) then
              folders.Add(Filepath(aPath, rec.Name));
          end
          else if Assigned(files) then
            files.Add(FilePath(aPath, rec.Name));

          Inc(count);

        until FindNext(rec) <> 0;

      finally
        FindClose(rec);
      end;

      // At this point we have identified files and folders that match the specified
      //  Pattern in the specified Path.  if we are running recursively we now need
      //  to look for ALL sub-folders of the Path.

      if fRecursive then
      begin
        if (FindFirst(aPath + '\*.*', faDirectory, rec) = 0) then
        try
          repeat
            if (rec.Name = '.') or (rec.Name = '..') then
              CONTINUE;

            if (rec.Attr and faDirectory) <> 0 then
              subfolders.Add(Path.Append(aPath, rec.Name))

          until FindNext(rec) <> 0;

        finally
          FindClose(rec);
        end;

        for i := 0 to Pred(subfolders.Count) do
          Find(subfolders[i], aPattern);
      end;
    end;

  var
    i: Integer;
  begin
    count := 0;

    if fFilesDest <> NIL then
    begin
      if fFilesDest^ = NIL then
        fFilesDest^ := TStringList.CreateManaged;

      files := fFilesDest^;
    end;

    if fFoldersDest <> NIL then
    begin
      if fFoldersDest^ = NIL then
        fFoldersDest^ := TStringList.CreateManaged;

      folders := fFoldersDest^;
    end;

    if fRecursive then
      FilePath := RecursiveFilePath
    else
      FilePath := NonRecursiveFilePath;

    if Length(fFilenames) > 0 then
    begin
      for i := 0 to High(fFilenames) do
        Find(fFolder, fFilenames[i]);
    end
    else
      Find(fFolder, '*.*');

    if Assigned(fCountDest) then
      fCountDest^ := count;

    result := count > 0;
  end;


  function TDirectory.Filename(const aValue: String): IDirectory;
  var
    i: Integer;
  begin
    for i := 0 to High(fFilenames) do
      if fFilenames[i] = aValue then
        EXIT;

    SetLength(fFilenames, Length(fFilenames) + 1);
    fFilenames[High(fFilenames)] := aValue;

    result := self;
  end;


  function TDirectory.Recursive: IDirectory;
  begin
    fRecursive := TRUE;
    result := self;
  end;


  function TDirectory.Recursive(const aValue: Boolean): IDirectory;
  begin
    fRecursive := aValue;
    result := self;
  end;


  function TDirectory.Yielding: IDirectoryYields;
  begin
    result := self;
  end;


  function TDirectory.Count(var aCount: Integer): IDirectory;
  begin
    fCountDest := @aCount;
    result := self;
  end;


  function TDirectory.Files(var aList: IStringList): IDirectory;
  begin
    fFilesDest := @aList;
    result := self;
  end;


  function TDirectory.Folders(var aList: IStringList): IDirectory;
  begin
    fFoldersDest := @aList;
    result := self;
  end;




end.
