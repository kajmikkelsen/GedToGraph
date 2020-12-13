program GedToGraph;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, memdslaz, Manin, UGedText, upersonliste, UGlobal,
  UAbout, UMailOgWeb, UVis;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFText, FText);
  Application.CreateForm(TFPersonliste, FPersonliste);
  Application.CreateForm(TFAbout, FAbout);
  Application.CreateForm(TFMailOgWeb, FMailOgWeb);
  Application.CreateForm(TFVis, FVis);
  Application.Run;
end.

