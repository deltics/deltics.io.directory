
{$apptype CONSOLE}

  program test;

uses
  Deltics.Smoketest,
  Deltics.IO.Directory in '..\src\Deltics.IO.Directory.pas',
  Deltics.IO.Directory.Interfaces in '..\src\Deltics.IO.Directory.Interfaces.pas',
  Deltics.IO.Directory.Implementation_ in '..\src\Deltics.IO.Directory.Implementation_.pas',
  Test.Directory in 'Test.Directory.pas';

begin
  TestRun.Test(DirectoryTests);
end.
