
{$i deltics.io.directory.inc}

  unit Deltics.IO.Directory.Builder;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.StringLists,
    Deltics.IO.Directory.Interfaces;


  type
    PStringList = ^IStringList;


    TDirectoryBuilder = class(TComInterfacedObject, IDirectoryBuilder,
                                                    IDirectoryYields)
    public // IDirectoryBuilder
      function Filename(const aValue: String): IDirectoryBuilder;
      function Recursive: IDirectoryBuilder; overload;
      function Recursive(const aValue: Boolean): IDirectoryBuilder; overload;
      function Yields: IDirectoryYields;
      function Execute: Boolean;
    public // IDirectoryYields
      function Count(var aCount: Integer): IDirectorybuilder;
      function Files(var aList: IStringList): IDirectorybuilder;
      function Folders(var aList: IStringList): IDirectorybuilder;

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

  constructor TDirectoryBuilder.Create(const aFolder: String);
  begin
    inherited Create;

    fFolder := aFolder;
  end;


  function TDirectoryBuilder.Execute: Boolean;
  var
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
    dir: String;
  begin
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

    dir := fFolder;

    if Length(fFilenames) > 0 then
    begin
      for i := 0 to High(fFilenames) do
        Find(dir, fFilenames[i]);
    end
    else
      Find(dir, '*.*');

    if Assigned(fCountDest) then
      fCountDest^ := files.Count + folders.Count;

    result := (files.Count + folders.Count) > 0;
  end;


  function TDirectoryBuilder.Filename(const aValue: String): IDirectoryBuilder;
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


  function TDirectoryBuilder.Recursive: IDirectoryBuilder;
  begin
    fRecursive := TRUE;
    result := self;
  end;


  function TDirectoryBuilder.Recursive(const aValue: Boolean): IDirectoryBuilder;
  begin
    fRecursive := aValue;
    result := self;
  end;


  function TDirectoryBuilder.Yields: IDirectoryYields;
  begin
    result := self;
  end;


  function TDirectoryBuilder.Count(var aCount: Integer): IDirectorybuilder;
  begin
    fCountDest := @aCount;
    result := self;
  end;


  function TDirectoryBuilder.Files(var aList: IStringList): IDirectorybuilder;
  begin
    fFilesDest := @aList;
    result := self;
  end;


  function TDirectoryBuilder.Folders(var aList: IStringList): IDirectorybuilder;
  begin
    fFoldersDest := @aList;
    result := self;
  end;




end.
