# Deltics.IO.Directory

Provides a fluent Api for obtaining lists of files and/or folders that exist in a specific
folder, matching a specified filename or pattern.

Example of use:

```
  var
    files: IStringList;
  begin
    Directory.OfFolder('c:\Windows')
      .Yielding.Count(files)
      .Execute;

    ..
  end;

```

Unless otherwise specified, the Directory will yield all files (and folders) in the specified
folder.  To obtain a directory of the current directory, the convenience method `OfCurrentDir`
may be used:

```
   Directory.OfCurrentDir
```

To obtain a directory of specific files, one or more Filenames may be specified, using wildcard
patterns as required.  For example, to obtain a list of all `mp4` and `mkv` files in the current
directory:

```
   var
     movies: IStringList;
   begin
     Directory.OfCurrentDir
       .Filename('*.mp4')
       .Filename('*.mkv')
       .Yielding.Files(movies)
       .Execute;

     ..
   end;
```


## Recursive Directories (Sub-Folders)

The default behaviour of Directory is non-recursive.  That is, it will return only files and folders
in the specified folder and not in any sub-folders.  Recursive behaviour may be specified by calling
the `Recursive` method on the Directory before `Execute`ing:

```
   var
     movies: IStringList;
   begin
     Directory.OfCurrentDir
       .Filename('*.mp4')
       .Filename('*.mkv')
       .Recursive
       .Yielding.Files(movies)
       .Execute;

     ..
   end;
```

The `Recursive` method may be called parameterless or with a boolean parameter to set the
required `Recursive` behaviour.  Calling the parameterless `Recursive` method is equiavalent to
calling `Recursive(TRUE)`.

**NOTE:** When performing a recursive Directory, the folders yield will contain _only_ those
folders that match the specified filename pattern(s).


## Yields

There are three possible yields from a Directory:

1. Count - yields the total count of files and folders that match the specified filename(s)
2. Files - yields a stringlist of files that match the specified filename(s)
3. Folders - yields a stringlist of folders that match the specified filename(s)

As many of these yields may be requested as required, but only once each.  Requesting multiple
yields of the same type results in the last yield requested being honoured and the earlier yield
ignored.

```
  var
    filesA, filesB: IStringList;
  begin
     Directory.OfCurrentDir
       .Yielding.Files(filesA)
       .Yielding.Files(filesB)
       .Execute;

     // filesA is NIL
     // filesB contains the directory of files
  end;
```

When specifiying `Files` and `Folders` yields, if an uninitialised interface reference (NIL) is
provided then the Directory will create a stringlist for you, to hold the yield.

If you specify an existing stringlist, the Directory will ADD the yield to any current contents of
that existing stringlist.
