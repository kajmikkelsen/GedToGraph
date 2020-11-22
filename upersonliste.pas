// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"
unit upersonliste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ComCtrls, PrintersDlgs, Printers;

type

  { TFPersonliste }

  TFPersonliste = class(TForm)
    BCreatTree: TButton;
    Edit1: TEdit;
    FD1: TFontDialog;
    AfslutButton: TButton;
    Label1: TLabel;
    PageControl1: TPageControl;
    PASD1: TPageSetupDialog;
    PD1: TPrintDialog;
    PSD1: TPrinterSetupDialog;
    SG1: TStringGrid;
    SG2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TV1: TTreeView;
    procedure AfslutButtonClick(Sender: TObject);
    procedure BCreatTreeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SG1HeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer
      );
    procedure SG1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    MedUdskrift: Boolean;
    Procedure DanForeldre(i,Generation,nr:Integer;ThisNode: TTreeNode);
    Procedure SetHeader;
    Procedure DrawTemplate(MyCanvas: TCanvas;Pwidth,PHeight:Integer);
    Procedure DrawForeldre(Gen,nr,i:Integer);
  public
    FileName: String;
    DoIndles: Boolean;
    Procedure IndLes;
  end;

var
  FPersonliste: TFPersonliste;

implementation
Uses
    MyLib,UGlobal;
{$R *.lfm}

{ TFPersonliste }
procedure TFPersonliste.SetHeader;
Begin
  SG1.cells[0,0] := 'ID';
  SG1.Cells[1,0] := 'Fornavn';
  SG1.Cells[2,0] := 'Efternavn';
  SG1.Cells[3,0] := 'Køn';
  SG1.Cells[4,0] := 'F. dato';
  SG1.Cells[5,0] := 'D. dato';
  SG1.Cells[6,0] := 'Fam no';
  SG2.Cells[0,0] := 'ID';
  SG2.Cells[1,0] := 'Mand';
  SG2.Cells[2,0] := 'Hustru';
  SG2.Cells[3,0] := 'Barn';
End;

procedure TFPersonliste.DrawTemplate(MyCanvas: TCanvas;Pwidth,PHeight:Integer);
begin
  myCanvas.Pen.Width:= 5;
  myCanvas.Rectangle(0,mmtopix(1),Pwidth,Pheight);
  DrawLine(myCanvas,10,1,10,288);
  DrawLine(myCanvas,25,1,25,288);
  DrawLine(myCanvas,45,1,45,288);
  DrawLine(myCanvas,70,1,70,288);
  DrawLine(myCanvas,120,1,120,288);

  DrawLine(myCanvas,10,144,201,144);

  DrawLine(myCanvas,25,72,201,72);
  DrawLine(myCanvas,25,216,201,216);

  DrawLine(myCanvas,45,36,201,36);
  DrawLine(myCanvas,45,108,201,108);
  DrawLine(myCanvas,45,180,201,180);
  DrawLine(myCanvas,45,252,201,252);

  DrawLine(myCanvas,70,18,201,18);
  DrawLine(myCanvas,70,54,201,54);
  DrawLine(myCanvas,70,90,201,90);
  DrawLine(myCanvas,70,126,201,126);
  DrawLine(myCanvas,70,162,201,162);
  DrawLine(myCanvas,70,198,201,198);
  DrawLine(myCanvas,70,234,201,234);
  DrawLine(myCanvas,70,270,201,270);

  DrawLine(myCanvas,120,9,201,9);
  DrawLine(myCanvas,120,27,201,27);
  DrawLine(myCanvas,120,45,201,45);
  DrawLine(myCanvas,120,63,201,63);
  DrawLine(myCanvas,120,81,201,81);
  DrawLine(myCanvas,120,99,201,99);
  DrawLine(myCanvas,120,117,201,117);
  DrawLine(myCanvas,120,135,201,135);
  DrawLine(myCanvas,120,153,201,153);
  DrawLine(myCanvas,120,171,201,171);
  DrawLine(myCanvas,120,189,201,189);
  DrawLine(myCanvas,120,207,201,207);
  DrawLine(myCanvas,120,225,201,225);
  DrawLine(myCanvas,120,243,201,243);
  DrawLine(myCanvas,120,261,201,261);
  DrawLine(myCanvas,120,279,201,279);

end;

procedure TFPersonliste.DrawForeldre(Gen, nr, i:Integer);
var
  x,y,tw: Integer;
  St1,St2,St3,St4: STring;
begin
  Case Gen of
    2: Begin
        St1 := Personer[i].Fornavn+' '+Personer[i].Efternavn;
        St2 := Personer[i].Fodselsdato+' - '+Personer[i].Dodsdato;
        Printer.canvas.Font.Orientation := 2700;
        tw := Printer.Canvas.TextWidth(St1);
        x := mmToPix(16);
        y := mmtopix((Nr-1)*144+72)-(tw div 2);
        Printer.canvas.textout(x,y,st1);
        tw := Printer.Canvas.TextWidth(St2);
        x := mmToPix(13);
        y := mmtopix((Nr-1)*144+72)-(tw div 2);
        Printer.canvas.textout(x,y,st2);
    end;
    3:Begin
      St1 := Personer[i].Fornavn+' '+Personer[i].Efternavn;
      St2 := Personer[i].Fodselsdato+' - '+Personer[i].Dodsdato;
      Printer.canvas.Font.Orientation := 2700;
      tw := Printer.Canvas.TextWidth(St1);
      x := mmToPix(34);
      y := mmtopix((Nr-1)*72+36)-(tw div 2);
      Printer.canvas.textout(x,y,st1);
      tw := Printer.Canvas.TextWidth(St2);
      x := mmToPix(31);
      y := mmtopix((Nr-1)*72+36)-(tw div 2);
      Printer.canvas.textout(x,y,st2);

    end;
    4:Begin
        St1 :=  Personer[i].Fornavn;
        St2 :=  Personer[i].Efternavn;
        St3 :=  Personer[i].Fodselsdato;
        St4 :=  Personer[i].Dodsdato;
        Printer.canvas.Font.Orientation := 2700;
        tw := Printer.Canvas.TextWidth(St1);
        x := mmToPix(60);
        y := mmtopix((Nr-1)*36+18)-(tw div 2);
        Printer.canvas.textout(x,y,st1);
        tw := Printer.Canvas.TextWidth(St2);
        x := mmToPix(57);
        y := mmtopix((Nr-1)*36+18)-(tw div 2);
        Printer.canvas.textout(x,y,st2);
        tw := Printer.Canvas.TextWidth(St3);
        x := mmToPix(54);
        y := mmtopix((Nr-1)*36+18)-(tw div 2);
        Printer.canvas.textout(x,y,st3);
        tw := Printer.Canvas.TextWidth(St4);
        x := mmToPix(51);
        y := mmtopix((Nr-1)*36+18)-(tw div 2);
        Printer.canvas.textout(x,y,st4);
    end;
    5:Begin
      St1 :=  Personer[i].Fornavn;
      St2 :=  Personer[i].Efternavn;
      St3 :=  Personer[i].Fodselsdato;
      St4 :=  Personer[i].Dodsdato;
      Printer.canvas.Font.Orientation := 0;
      tw := Printer.Canvas.TextWidth(St1);
      x := mmToPix(95)-(tw div 2);
      y := mmtopix((Nr-1)*18+3);
      Printer.canvas.textout(x,y,st1);
      tw := Printer.Canvas.TextWidth(St2);
      x := mmToPix(95)-(tw div 2);;
      y := mmtopix((Nr-1)*18+6);
      Printer.canvas.textout(x,y,st2);
      tw := Printer.Canvas.TextWidth(St3);
      x := mmToPix(95)-(tw div 2);;
      y := mmtopix((Nr-1)*18+10);
      Printer.canvas.textout(x,y,st3);
      tw := Printer.Canvas.TextWidth(St4);
      x := mmToPix(95)-(tw div 2);;
      y := mmtopix((Nr-1)*18+13);
      Printer.canvas.textout(x,y,st4);

    end;
    6:Begin
      St1 :=  Personer[i].Fornavn+' '+Personer[i].Efternavn;
      St2 :=  Personer[i].Fodselsdato+' - '+Personer[i].Dodsdato;
      Printer.canvas.Font.Orientation := 0;
      tw := Printer.Canvas.TextWidth(St1);
      x := mmToPix(160)-(tw div 2);
      y := mmtopix((Nr-1)*9+1);
      Printer.canvas.textout(x,y,st1);
      tw := Printer.Canvas.TextWidth(St2);
      x := mmToPix(160)-(tw div 2);;
      y := mmtopix((Nr-1)*9+4);
      Printer.canvas.textout(x,y,st2);
    end;
    7: Begin
        Printer.canvas.Font.Orientation := 0;
         x := mmToPix(198);
         y := mmToPix((nr-1)*9 div 2);
         Printer.canvas.textout(x,y,'+');
    end;
  end;
end;

procedure TFPersonliste.IndLes;
Var
  Fl: TextFile;
  St,ID: String;
  I,i1: Integer;
  Slut: Boolean;
  SaveCursor: Tcursor;
  FamNo: String;
begin
  PageControl1.ActivePage := Tabsheet1;
  DoIndles := False;
  FokusPerson := 0;
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  SG1.Clean;
  SG2.Clean;
  TV1.Items.Clear;
  FillChar(Personer,SizeOf(personer),#0);
  FillChar(Familier,SizeOf(familier),#0);
  Slut := False;
  I := 1;
  i1 := 1;
  AssignFile(Fl,FileName);
  Reset(Fl);
  While Not Slut Do
  Begin
    Readln(Fl,St);
    Edit1.text := 'Pre: '+St;
    Application.ProcessMessages;
    If Pos('0',St) = 1 Then
      If Pos('INDI',St) > 0 Then
        Slut := True;
    If EoF(Fl) Then Slut := True;
  end;
  If Not Slut then
    ShowMessage('Ugyldig GedCom fil')
  Else
  Begin
    While Not EoF(Fl) Do
    Begin
      If Pos('INDI',St) > 0 Then
      Begin
        ID := GetFieldByDelimiter(1,st,'@');
        SG1.RowCount := i+1;
        If SG1.Rowcount = 2 Then
          SetHeader;
        SG1.Cells[0,i] := ID;
        Inc(i);
        Slut := False;
        While Not Slut Do
        Begin
          ReadLn(Fl,St);
          Edit1.text := 'behandler: '+St;
          Application.ProcessMessages;
          If Pos('0',St) <> 1 Then
          Begin
            If Eof(Fl) Then
              Slut := True
            Else
            Begin
              If Pos('GIVN',St) = 3 then
              Begin
                SG1.Cells[1,i-1] := Copy(St,8,Length(St)-7);
              End;
              If Pos('SURN',St) = 3 Then
                SG1.Cells[2,i-1] := Copy(St,8,Length(St)-7);
              If Pos('SEX',St) = 3 Then
                SG1.Cells[3,i-1] := Copy(St,7,1);
              If Pos('BIRT',st) = 3 Then
              Begin
                Readln(fl,st);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[4,i-1] := Copy(St,8,Length(St)-7);
              end;
              If Pos('DEAT',St) = 3 Then
              Begin
                Readln(fl,st);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[5,i-1] := Copy(St,8,Length(St)-7);
              end;
              If Pos('FAMC',St) = 3 Then
              Begin
                FamNo := GetFieldByDelimiter(1,St,'@');
                Readln(fl,st);
                if pos('birth',st) > 0 Then
                  SG1.Cells[6,i-1] := FamNo;;
              end;
            End;
          End
          Else
            Slut := True;
          End;
        End
      Else
      Begin
        If Pos('@F',st) = 3 Then
        Begin
          // Read family records
          ID := GetFieldByDelimiter(1,st,'@');
          SG2.RowCount := i1+1;
          SG2.Cells[0,i1] := ID;
          Inc(i1);
          Slut := False;
          While Not Slut Do
          Begin
            ReadLn(Fl,St);
            Application.ProcessMessages;
            Edit1.text := 'behandler: '+St;
            If Pos('0',St) <> 1 Then
            Begin
              If Pos('HUSB',St) = 3 Then
                SG2.Cells[1,i1-1] := GetFieldByDelimiter(1,st,'@');
              If Pos('WIFE',St) = 3 Then
                SG2.Cells[2,i1-1] := GetFieldByDelimiter(1,st,'@');
              If Pos('CHIL',St) = 3 Then
                SG2.Cells[3,i1-1] := GetFieldByDelimiter(1,st,'@');
            end
            else
              Slut := True;
          end;
        end
        Else
        Begin
          ReadLn(Fl,St);
          Edit1.Text := St;
          application.processmessages;
        end;
        //DoSomethingElse
      end;
    end;
    CloseFile(fl);
// now read the stuff into the arrays
    for I := 1 to SG1.RowCount-1 Do
    Begin
      i1 := StrToInt(RightStr(SG1.Cells[0,i],4));
      Personer[i1].ID:= SG1.Cells[0,i];
      Personer[i1].Fornavn:= SG1.Cells[1,i];
      Personer[i1].Efternavn:= SG1.Cells[2,i];
      Personer[i1].Fodselsdato := SG1.Cells[4,i];
      Personer[i1].Dodsdato := SG1.Cells[5,i];
      Personer[i1].familie := RightStr(SG1.Cells[6,i],4);
    end;
    For i := 1 To SG2.RowCount -1 Do
    Begin
      i1 := StrToInt(RightStr(SG2.Cells[0,i],4));
      Familier[i1].ID := RightStr(SG2.Cells[0,i],4);
      Familier[i1].Fader := RightStr(SG2.Cells[1,i],4);
      Familier[i1].Moder := RightStr(SG2.Cells[2,i],4);
      Familier[i1].Barn := RightStr(SG2.Cells[2,i],4);
    end;
  end;
  FokusPerson := 0;
  Edit1.Text := 'Ikke valgt';
  Screen.Cursor := SaveCursor;

end;

procedure TFPersonliste.FormCreate(Sender: TObject);
begin
  RestoreForm(FPersonListe);
  GetGridCols(SG1,'personliste');
  GetGridCols(SG2,'familieliste');
  SetHeader;
  PageControl1.ActivePage := Tabsheet1;
  DoIndles := False;
end;


procedure TFPersonliste.AfslutButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFPersonliste.BCreatTreeClick(Sender: TObject);
Var
  mrRes: Word;
  i,TWidth: Integer;
  MyNode: TTreeNode;
  St1,St2: STring;

begin
  TV1.Items.Clear;
  If FokusPerson = 0 Then
    Showmessage('Vælg fokusperson ved at klikke på personen i listen')
  Else
  Begin
      if  MyYesNoDlg('Med udskrift?') = mrYes then
//      if MessageDlg('Med udskrift',mtCOnfirmation,[mbYes, mbNo],0) = mrYes Then
      MedUdskrift := True
    Else
      MedUdskrift := False;
    i := FokusPerson;
    MyNode := TV1.Items.Add(nil,Personer[i].Fornavn+' '+Personer[i].Efternavn+' 1');
    If MedUdskrift Then
    Begin
      With Printer do
      Try
        BeginDoc;
        SetPixelsPrmm(Canvas);
        DrawTemplate(Canvas,PageWidth,PageHeight);
        St1 := Personer[i].Fornavn+' '+Personer[i].Efternavn;
        St2 := Personer[i].Fodselsdato+' - '+Personer[i].Dodsdato;
        Canvas.Font.Name := 'Courier New';
        Canvas.Font.Size := 8;
        Canvas.Font.Color := clBlack;
        Canvas.Font.Orientation:= 2700;
        TWidth := canvas.TextWidth(St1);
        Canvas.TextOut(mmtopix(4),mmtopix(144) - TWidth div 2  , St1);
        TWidth := canvas.TextWidth(St2);
        Canvas.TextOut(mmtopix(0),mmtopix(144)-TWidth div 2 , St2);
        DanForeldre(i,1,1,MyNode);
      finally
        EndDoc
      end;
    End
    Else
    Begin
    DanForeldre(i,1,1,MyNode);

    end;
    PageControl1.ActivePage := Tabsheet3;;
  end;
end;

procedure TFPersonliste.FormDestroy(Sender: TObject);
begin
  SaveGridCols(SG1,'personliste');
  SaveGridCols(SG2,'familieliste');
SaveForm(FPersonListe);
end;

procedure TFPersonliste.FormShow(Sender: TObject);
begin
  If DoIndles Then Indles;
end;

procedure TFPersonliste.SG1HeaderClick(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
begin
  If Index < 4 Then
    SG1.SortColRow(IsColumn,Index);
end;

procedure TFPersonliste.SG1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  Edit1.Text := SG1.Cells[0,aRow];
  If Sg1.Cells[0,aRow] <> '' Then
  Begin
     FokusPerson := StrToInt(RightStr(SG1.Cells[0,aRow],4));
     Edit1.Text := Personer[FokusPerson].Fornavn + ' '+ Personer[FokusPerson].Efternavn;
  end;
end;

procedure TFPersonliste.DanForeldre(i,Generation,nr:Integer; ThisNode: TTreeNode);
Var
  Fam,fader,moder:Integer;
  MyNode: TTreeNode;
begin
  Inc(Generation);
  If Personer[i].familie <> '' Then
  Begin
    fam := StrToInt(Personer[i].familie);
    If Familier[fam].Fader <> '' Then
    Begin
        Fader := StrToInt(Familier[fam].Fader);
        If MedUdskrift Then
          DrawForeldre(Generation, nr*2-1, Fader);
        MyNode := TV1.Items.AddChild(ThisNode,Personer[fader].Fornavn+' '+Personer[fader].Efternavn+' '+IntToStr(Generation)+' '+IntToStr(nr*2-1));
        DanForeldre(Fader,Generation,nr*2-1,MyNode);
     End;
    If Familier[fam].moder <> '' Then
    Begin
        moder := StrToInt(Familier[fam].moder) ;
        If MedUdskrift Then
          DrawForeldre(Generation, nr*2, Moder);
        MyNode := TV1.Items.AddChild(ThisNode,Personer[moder].Fornavn+' '+Personer[moder].Efternavn+' '+IntToStr(Generation)+' '+IntToStr(nr*2));
        DanForeldre(Moder,Generation,nr*2,MyNode);
     End;
  end;
end;

end.

