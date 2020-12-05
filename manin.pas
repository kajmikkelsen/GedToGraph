// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"

(* Version history
0.02
Rettet så individnummeret ikke skal være på 4 karakterer
Rettet Så familien ikke er afhængig af en birth record
Rettet Så navnet trækkes fra NAME record Og ikke nødvendigvis GIVN og SURN
Tilføjet versionering i projekt sourcen
Tilføje drag and drop af filer
0.0.3.0
Afhjalp problem med to hold forældre
Tilføjet knap med mulighed for at vælge printer
0.0.4.0
Flyttet personer fra array til tmemdataset, da ID kan være større end 9999
Sat generationer til max 10 ved dan træ, så uendelig rekursivitet udgås.
Ændret indlæsning af personer, så alle personer kommer med i alle testede tilfælde
Rettet udskrift til, så det ser korrekt ud på både windows og linux
Rettet så UTF16 læses på både windows og linux
0.0.5.0
Lagt til at bruger kan vælge font.
Rettet udskrift mht nederste bokse
0.0.6.0
Changed so both UTF16BE and UTF16 Files can be read
Added doubleclick event for sg1
fedtet med udskriften
Tillagt overskrift og oplysninger om udskriften
Udskriften husker nu sidst brugte font

*)
unit Manin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  StdCtrls,Printers, ExtCtrls;

type

  { TFMain }

  TFMain = class(TForm)
    AAfslut: TAction;
    Aabn: TAction;
    AAbout: TAction;
    AFejlOgWeb: TAction;
    APersonliste: TAction;
    AGedText: TAction;
    ActionList1: TActionList;
    Image1: TImage;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MGEdcomSomText: TMenuItem;
    N1: TMenuItem;
    MOpen: TMenuItem;
    MExit: TMenuItem;
    OD1: TOpenDialog;
    procedure AabnExecute(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure AAfslutExecute(Sender: TObject);
    procedure AFejlOgWebExecute(Sender: TObject);
    procedure APersonlisteExecute(Sender: TObject);
    procedure AGedTextExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  private

  public

  end;

var
  FMain: TFMain;

implementation

{$R *.lfm}
Uses
    MyLib,UGedText,upersonliste,UAbout,UMailOgWeb;

{ TFMain }

procedure TFMain.AAfslutExecute(Sender: TObject);
begin
  Application.terminate;
end;

procedure TFMain.AFejlOgWebExecute(Sender: TObject);
begin
  FMailOgWeb.ShowModal;
end;

procedure TFMain.APersonlisteExecute(Sender: TObject);
begin
  If Od1.FileName <> '' Then
  Begin
    FpersonListe.FileName := OD1.Filename;
    FPersonliste.DoIndles := True;
    Fpersonliste.Show;
  end
  else
    ShowMessage('Vælg gedcom fil først');

end;

procedure TFMain.AGedTextExecute(Sender: TObject);
begin
    Ftext.Label1.Caption:= OD1.FileName;
    FText.Show;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  RestoreForm(FMain);
  ClearLog;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  SaveForm(FMain);
end;

procedure TFMain.FormDropFiles(Sender: TObject; const FileNames: array of String
  );
begin
  Od1.FileName := Filenames[0];
  APersonliste.Execute;
end;

procedure TFMain.AabnExecute(Sender: TObject);
begin
  If OD1.Execute Then
  Begin
    APersonliste.Execute;
  end;
end;

procedure TFMain.AAboutExecute(Sender: TObject);
begin
  FAbout.ShowModal;
end;

end.

