//
// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"
unit upersonliste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, memds, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ComCtrls, PrintersDlgs, Printers,AvgLvlTree,LazUTF8,UGedText;

type

  { TFPersonliste }

  TFPersonliste = class(TForm)
    BCreatTree: TButton;
    BFont: TButton;
    Edit1: TEdit;
    FD1: TFontDialog;
    AfslutButton: TButton;
    Label1: TLabel;
    Indi: TMemDataset;
    Fami: TMemDataset;
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
    procedure BFontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SG1HeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer
      );
    procedure SG1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private

    SlutY,x1,x2,x3,x4,x5,x6,X7,y0,y1,y2,y3,y4,y5,y6,y7,offset:Real;

    Forhold: Real;
    MedUdskrift,FontValgt: Boolean;
    LC,Margininpix: Integer;
    Procedure DanForeldre(i,Generation,nr:Integer;ID:String;ThisNode: TTreeNode);
    Procedure SetHeader;
    Procedure DrawTemplate(MyCanvas: TCanvas);
    Procedure DrawForeldre(Gen,nr:Integer;ID:String);
    Procedure ReadFromList(Var St:String);
  public
    FileName: String;
    DoIndles: Boolean;
    Margin: Integer;
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

procedure TFPersonliste.DrawTemplate(MyCanvas: TCanvas);
begin
  myCanvas.Pen.Width:= 5;
  forhold := (210-2*margin)/210;
  Sluty := mmToPix(297-Margin*2+2);
  X1 := Margin;
  x7 := 210-Margin;
  x2 := (Margin+10)*Forhold;
  x3 := (Margin+25)*Forhold;
  x4 := (Margin+45)*ForHold;
  x5 := (Margin+70)*forhold;
  x6 := (Margin+120)*Forhold;
  y0 := (Margin);
  y1 := (297*forhold)/2;
  y2 := (297*forhold)/4;
  y3 := (297*forhold)/8;
  y4 := (297*forhold)/16;
  y5 := (297*forhold)/32;
  y6 := 297-Margin*2+2;
  y7 := 1;



  myCanvas.Rectangle(rmmtopix(x1),rmmtopix(y0),rmmToPix(x7),Trunc(Sluty));
  DrawLine(myCanvas,X2,Margin,X2,y6);
  DrawLine(myCanvas,X3,Margin,x3,y6);
  DrawLine(myCanvas,X4,Margin,X4,y6);
  DrawLine(myCanvas,X5,Margin,X5,y6);
  DrawLine(myCanvas,X6,Margin,X6,y6);

  DrawLine(myCanvas,X2,Margin+Y1,X7,Margin+Y1);

  DrawLine(myCanvas,X3,Margin+Y2,X7,Margin+Y2);
  DrawLine(myCanvas,X3,Margin+Y2*3,X7,Margin+Y2*3);

  DrawLine(myCanvas,x4,Margin+y3,X7,Margin+y3);
  DrawLine(myCanvas,X4,Margin+y3*3,X7,Margin+y3*3);
  DrawLine(myCanvas,X4,Margin+y3*5,X7,Margin+y3*5);
  DrawLine(myCanvas,X4,Margin+y3*7,X7,Margin+y3*7);

  DrawLine(myCanvas,X5,Margin+y4,X7,Margin+y4);
  DrawLine(myCanvas,X5,Margin+y4*3,X7,Margin+y4*3);
  DrawLine(myCanvas,X5,Margin+y4*5,X7,Margin+y4*5);
  DrawLine(myCanvas,X5,Margin+y4*7,X7,Margin+y4*7);
  DrawLine(myCanvas,X5,Margin+y4*9,X7,Margin+y4*9);
  DrawLine(myCanvas,X5,Margin+y4*11,X7,Margin+y4*11);
  DrawLine(myCanvas,X5,Margin+y4*13,X7,Margin+y4*13);
  DrawLine(myCanvas,X5,Margin+y4*15,X7,Margin+y4*15);

  DrawLine(myCanvas,X6,Margin+y5,X7,Margin+y5);
  DrawLine(myCanvas,X6,Margin+y5*3,X7,Margin+y5*3);
  DrawLine(myCanvas,X6,Margin+y5*5,X7,Margin+y5*5);
  DrawLine(myCanvas,X6,Margin+y5*7,X7,Margin+y5*7);
  DrawLine(myCanvas,X6,Margin+y5*9,X7,Margin+y5*9);
  DrawLine(myCanvas,X6,Margin+y5*11,X7,Margin+y5*11);
  DrawLine(myCanvas,X6,Margin+y5*13,X7,Margin+y5*13);
  DrawLine(myCanvas,X6,Margin+y5*15,X7,Margin+y5*15);
  DrawLine(myCanvas,X6,Margin+y5*17,X7,Margin+y5*17);
  DrawLine(myCanvas,X6,Margin+y5*19,X7,Margin+y5*19);
  DrawLine(myCanvas,X6,Margin+y5*21,X7,Margin+y5*21);
  DrawLine(myCanvas,X6,Margin+y5*23,X7,Margin+y5*23);
  DrawLine(myCanvas,X6,Margin+y5*25,X7,Margin+y5*25);
  DrawLine(myCanvas,X6,Margin+y5*27,X7,Margin+y5*27);
  DrawLine(myCanvas,X6,Margin+y5*29,X7,Margin+y5*29);
  DrawLine(myCanvas,X6,Margin+y5*31,X7,Margin+y5*31);

end;

procedure TFPersonliste.DrawForeldre(Gen, nr:Integer;ID: String);
var
  x,y:Real;
  tw,i: Integer;
  St1,St2,St3,St4: STring;
  Found: Boolean;
begin
  Found := Indi.Locate('ID',ID,[]);
  If Found Then
  Begin
    Case Gen of
      2: Begin
          St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
          St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
          Printer.canvas.Font.Orientation := 2700;
          tw := Printer.Canvas.TextWidth(St1);
          i := Printer.canvas.font.height;
          x := rmmtopix(x2)-Printer.canvas.Font.Height*2+Offset;
          y := rmmtopix(Margin)+rmmtopix((Nr-1)*y1+(y1/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st1);
          tw := Printer.Canvas.TextWidth(St2);
          x := rmmToPix(x2)-Printer.canvas.font.height+Offset;
          y := rmmtopix(Margin)+rmmtopix((Nr-1)*y1+(y1/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st2);
      end;
      3:Begin
        St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
        St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
        Printer.canvas.Font.Orientation := 2700;
        tw := Printer.Canvas.TextWidth(St1);
        x := rmmToPix(x3)-Printer.canvas.font.height*2+Offset;
        y := rmmtopix(Margin)+rmmtopix((Nr-1)*y2+(y2/2))-(tw/2);
        Printer.canvas.textout(Trunc(x),Trunc(y),st1);
        tw := Printer.Canvas.TextWidth(St2);
        x := rmmToPix(x3)-Printer.canvas.font.height+Offset;
        y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y2+(y2/2))-(tw/2);
        Printer.canvas.textout(Trunc(x),Trunc(y),st2);

      end;
      4:Begin
          St1 := Indi.FieldByName('Fornavn').AsString;
          St2 := Indi.FieldByName('Efternavn').AsString;
          St3 := Indi.FieldByName('FodDato').AsString;
          St4 := Indi.FieldByName('DodDato').AsString;
          Printer.canvas.Font.Orientation := 2700;
          tw := Printer.Canvas.TextWidth(St1);
          x := rmmToPix(x4)-Printer.canvas.font.height*5+Offset;
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st1);
          tw := Printer.Canvas.TextWidth(St2);
          x := rmmToPix(x4)-Printer.canvas.font.height*4+Offset;
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st2);
          tw := Printer.Canvas.TextWidth(St3);
          x := rmmToPix(x4)-Printer.canvas.font.height*3+Offset;
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st3);
          tw := Printer.Canvas.TextWidth(St4);
          x := rmmToPix(x4)-Printer.canvas.font.height*2+Offset;
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          Printer.canvas.textout(Trunc(x),Trunc(y),st4);
      end;
      5:Begin
        St1 := Indi.FieldByName('Fornavn').AsString;
        St2 := Indi.FieldByName('Efternavn').AsString;
        St3 := Indi.FieldByName('FodDato').AsString;
        St4 := Indi.FieldByName('DodDato').AsString;
        Printer.canvas.Font.Orientation := 0;
        tw := Printer.Canvas.TextWidth(St1);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1))*y4-Printer.canvas.font.Height*1;
        Printer.canvas.textout(Trunc(x),Trunc(y),st1);
        tw := Printer.Canvas.TextWidth(St2);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1))*y4-Printer.canvas.font.Height*2;
        Printer.canvas.textout(Trunc(x),Trunc(y),st2);
        tw := Printer.Canvas.TextWidth(St3);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1))*y4-Printer.canvas.font.Height*3;
        Printer.canvas.textout(Trunc(x),Trunc(y),st3);
        tw := Printer.Canvas.TextWidth(St4);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1))*y4-Printer.canvas.font.Height*4;
        Printer.canvas.textout(Trunc(x),Trunc(y),st4);

      end;
      6:Begin
        St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
        St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
        Printer.canvas.Font.Orientation := 0;
        tw := Printer.Canvas.TextWidth(St1);
        x := rmmtopix(x6+(x7-x6)/2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y5)+rmmtopix(y7);
        Printer.canvas.textout(Trunc(x),Trunc(y),st1);
        tw := Printer.Canvas.TextWidth(St2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y5)+rmmtopix(y7)-Printer.canvas.font.Height;
        x := rmmtopix(x6+(x7-x6)/2) -(tw/2);
        Printer.canvas.textout(Trunc(x),Trunc(y),st2);
      end;
      7: Begin
          Printer.canvas.Font.Orientation := 0;
           x := rmmtopix(x7)-rmmtopix(2);
           y := rmmtopix(Margin)+rmmtopix((nr-1)*y5/2)+rmmtopix(y7);
           Printer.canvas.textout(Trunc(x),Trunc(y),'+');
      end;
  end;
  End;
end;

procedure TFPersonliste.ReadFromList(var St: String);
begin
  St := MyLines[lc];
  Inc(lc);
end;

procedure TFPersonliste.IndLes;
Var
  Fl: File Of Byte;
  Fl1: Text;
  St,St1, ID: String;
  I,i1,i2: Integer;
  Slut,UTF: Boolean;
  SaveCursor: Tcursor;
  FamNo: String;
  MS: TMemoryStream;
  BOM: Array[1..3] of byte;
  cp: word;
begin
  PageControl1.ActivePage := Tabsheet1;
  DoIndles := False;
  FokusPerson := '';
  indi.Clear(False);
  fami.clear(False);
  Indi.Open;
  Fami.Open;
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  SG1.Clean;
  SG2.Clean;
  TV1.Items.Clear;
  Slut := False;
  I := 1;
  I1 := 1;
  LC := 0;
  Margin := 10;
  UTF := False;
{$IFDEF linux}
  AssignFile(Fl,FileName);
  Reset(Fl);
  Read(Fl,BOM[1]);
  Read(Fl,BOM[2]);
  CloseFile(Fl);
  If (BOM[1]=255) and (BOM[2] = 254) Then UTF := True;
  If (BOM[1]=254) and (BOM[2] = 255) Then UTF := True;
{$ENDIF}
  MyLines := TStringList.Create;
  If UTF Then
  Begin
    MS := TMemoryStream.Create;
    Try
      MS.LoadFromFile(FileName);
      MS.Position := 0;
      St := UTF16ToUTF8(PWideChar(MS.Memory), MS.Size div SizeOf(WideChar));
      MyLines.Text := St;
    finally
      MS.Free;
    end;
  End
  Else
    MyLines.LoadFromFile(FileName);
  While Not Slut Do
  Begin
    ReadFromList(St);
    WriteLog('1: '+St);
    i2 := Length(St);
    Edit1.text := 'Pre: '+St+ ' '+ IntToStr(i2);
    Application.ProcessMessages;
    If Pos('0',St) = 1 Then
      If Pos('INDI',St) > 0 Then
        Slut := True;
    If LC = MyLines.Count - 1 Then Slut := True;
  end;
  If Not Slut then
    ShowMessage('Ugyldig GedCom fil')
  Else
  Begin
    While LC < MyLines.Count Do
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
          ReadFromList(St);
          WriteLog('2: '+St);
          Edit1.text := 'behandler: '+St;
          Application.ProcessMessages;
          If Pos('0',St) <> 1 Then
          Begin
            If LC = MyLines.Count -1  Then
              Slut := True
            Else
            Begin
              If Pos('GIVN',St) = 3 then
              Begin
                SG1.Cells[1,i-1] := Copy(St,8,Length(St)-7);
              End;
              If Pos('SURN',St) = 3 Then
                SG1.Cells[2,i-1] := Copy(St,8,Length(St)-7);
              If Pos('NAME',St) = 3 Then
              begin
                St1 := Copy(St,8,Length(St)-7);
                i2 := Pos('/',St1);
                SG1.Cells[1,i-1] := Copy(St1,1,i2-1);
                Delete(St1,1,I2);
                SG1.Cells[2,i-1] := Copy(St1,1,Length(St1)-1);
              end;


              If Pos('SEX',St) = 3 Then
                SG1.Cells[3,i-1] := Copy(St,7,1);
              If Pos('BIRT',st) = 3 Then
              Begin
                ReadFromList(St);
                WriteLog('3: '+St);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[4,i-1] := Copy(St,8,Length(St)-7);
              end;
              If Pos('DEAT',St) = 3 Then
              Begin
                ReadFromList(St);
                WriteLog('4: '+St);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[5,i-1] := Copy(St,8,Length(St)-7);
              end;
              If Pos('FAMC',St) = 3 Then
              Begin
                FamNo := GetFieldByDelimiter(1,St,'@');
                ReadFromList(St);
                WriteLog('5: '+St);
                If Pos('PEDI',St) > 0 Then
                begin
                  if pos('birth',st) > 0 Then
                    SG1.Cells[6,i-1] := FamNo;
                end
                Else
                Begin
                  SG1.Cells[6,i-1] := FamNo;
                  dec(lc);
                end;

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
            ReadFromList(St);
            WriteLog('6: '+St);
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
          ReadFromList(St);
          WriteLog('7: '+St);
          Edit1.Text := St;
          application.processmessages;
        end;
        //DoSomethingElse
      end;
    end;
// now read the stuff into the arrays
    for I := 1 to SG1.RowCount-1 Do
    Begin
      Indi.Append;
      Indi.fieldbyname('ID').AsString := SG1.Cells[0,i];
      Indi.fieldbyname('Fornavn').AsString := SG1.Cells[1,i];
      Indi.fieldbyname('Efternavn').AsString := SG1.Cells[2,i];
      Indi.fieldbyname('Kon').AsString := SG1.Cells[3,i];
      Indi.fieldbyname('FodDato').AsString := SG1.Cells[4,i];
      Indi.fieldbyname('DodDato').AsString := SG1.Cells[5,i];
      Indi.fieldbyname('Fam').AsString := SG1.Cells[6,i];
      Indi.Post;
    end;
    For i := 1 To SG2.RowCount -1 Do
    Begin
      Fami.Append;
      Fami.FieldByName('ID').AsString := SG2.Cells[0,i];
      Fami.FieldByName('Mand').AsString := SG2.Cells[1,i];
      Fami.FieldByName('Hustru').AsString := SG2.Cells[2,i];
      Fami.FieldByName('Barn').AsString := SG2.Cells[3,i];
      Fami.Post;
    end;
  end;
  FokusPerson := '';
  Edit1.Text := 'Ikke valgt';
  IF SG1.RowCount > 1 Then
  Begin
    FokusPerson := SG1.Cells[0,1];
    Edit1.Text := SG1.Cells[1,1] + ' '+SG1.Cells[2,1];
  end;
  Screen.Cursor := SaveCursor;
  FText.Memo1.Lines.Assign(MyLines);
  MyLines.Free;
end;

procedure TFPersonliste.FormCreate(Sender: TObject);
Var
    St:String;
begin
  RestoreForm(FPersonListe);
  GetGridCols(SG1,'personliste');
  GetGridCols(SG2,'familieliste');
  SetHeader;
  PageControl1.ActivePage := Tabsheet1;
  DoIndles := False;
  St := GetStdIni('Font','Name','None');
  If St <> 'None' Then
  Begin
    FD1.Font.Name := St;
    FD1.Font.Size := StrToInt(GetStdIni('Font','Size','8'));
    FD1.Font.Height := StrToInt(GetStdIni('Height','Height','-11'));
  end;

end;


procedure TFPersonliste.AfslutButtonClick(Sender: TObject);
begin
  Close;

end;

procedure TFPersonliste.BCreatTreeClick(Sender: TObject);
Var
  i,TWidth: Integer;
  MyNode: TTreeNode;
  St1,St2: STring;

begin
  TV1.Items.Clear;
  If FokusPerson = '' Then
    Showmessage('Vælg fokusperson ved at klikke på personen i listen')
  Else
  Begin
      if  MyYesNoDlg('Med udskrift?') = mrYes then
//      if MessageDlg('Med udskrift',mtCOnfirmation,[mbYes, mbNo],0) = mrYes Then
      MedUdskrift := True
    Else
      MedUdskrift := False;
    If MedUdskrift Then
      If Not PD1.Execute Then Exit;
    Indi.Locate('ID',FokusPerson,[]);
    MyNode := TV1.Items.Add(nil,Indi.FieldByName('Fornavn').AsString+' '+Indi.FieldByName('EfterNavn').AsString+' 1');
    If MedUdskrift Then
    Begin
      With Printer do
      Try
        BeginDoc;
//        Printer.Canvas.Font.Size := 8;
//        Printer.Canvas.Font := FD1.Font;
//        Printer.Canvas.font.name := 'Karumbi';
        St1 := GetStdIni('Font','Name','None');
        If ST1 <> 'None' Then
        Begin
          Printer.Canvas.font.name := St1;
          Printer.Canvas.font.size := StrToInt(GetStdIni('Font','Size','8'));
        end;
//        Printer.Canvas.font.Height := -11;
        SetPixelsPrmm(Canvas);
        Margininpix := mmtopix(Margin);
        DrawTemplate(Canvas);
        St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
        St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
        Canvas.Font.Color := clBlack;
        Canvas.Font.Orientation:= 2700;
        TWidth := canvas.TextWidth(St1);
        i := Canvas.Font.Height;
        {$IFDEF windows }
        Offset := -(Trunc(canvas.font.Height*1.5));
        {$ENDIF }
        {$IFDEF linux}
        Offset := 0;
        {$ENDIF}
//        Canvas.TextOut(mmtopix(X1)-canvas.font.Height+Offset,mmtopix(Margin+y1) - TWidth div 2  , St1);
        Canvas.TextOut(Trunc(rmmtopix(X1))-canvas.font.Height+Trunc(Offset),Trunc(rmmtopix(Margin+y1)) - TWidth div 2  , St1);
        TWidth := canvas.TextWidth(St2);
        Canvas.TextOut(Trunc(rmmtopix(X1))+Trunc(Offset),Trunc(rmmtopix(Margin+y1)-TWidth/2) , St2);
        DanForeldre(i,1,1,Indi.FieldByName('ID').AsString,MyNode);
      finally
        EndDoc
      end;
    End
    Else
    Begin
    DanForeldre(i,1,1,Indi.FieldByName('ID').AsString,MyNode);

    end;
    PageControl1.ActivePage := Tabsheet3;;
  end;
end;

procedure TFPersonliste.BFontClick(Sender: TObject);
begin
  If FD1.Execute Then
  Begin
    Printer.Canvas.Font := FD1.Font;
    FontValgt := True;
    PutStdIni('Font','Name',FD1.Font.Name);
    PutStdIni('Font','Size',IntToStr(FD1.Font.Size));
    PutStdIni('Height','Height',IntToStr(FD1.Font.Height));
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
//     FokusPerson := StrToInt(Rm1stChar(SG1.Cells[0,aRow]));
     FokusPerson := SG1.Cells[0,aRow];
     Indi.Locate('ID',SG1.Cells[0,aRow],[]);
     Edit1.Text := Indi.FieldByName('Fornavn').AsString+' '+Indi.FieldByName('Efternavn').AsString;
  end;
end;

procedure TFPersonliste.DanForeldre(i,Generation,nr:Integer;ID:String; ThisNode: TTreeNode);
Var
  MyNode: TTreeNode;
  St:String;
  Fader,Moder:Integer;
begin
  Application.ProcessMessages;
  Inc(Generation);
  Fader := i;
  Moder := i+1;
  If Generation > 10 Then
    exit;
  Indi.Locate('ID',ID,[]);
  St := Indi.fieldbyname('Fam').AsString;
  If St <> '' Then
  Begin
    Fami.Locate('ID',Indi.fieldbyname('Fam').AsString,[]);
    If Fami.FieldByName('Mand').AsString <> '' Then
    Begin
        If MedUdskrift Then
          DrawForeldre(Generation, nr*2-1, Fami.FieldByName('Mand').AsString);
        Indi.Locate('ID',Fami.fieldbyname('Mand').AsString,[]);
        MyNode := TV1.Items.AddChild(ThisNode,Indi.FieldByName('ForNavn').AsString+' '+Indi.FieldByName('Efternavn').AsString+' '+IntToStr(Generation)+' '+IntToStr(nr*2-1));
        DanForeldre(Fader,Generation,nr*2-1,Fami.fieldbyname('Mand').AsString,MyNode);
     End;
    Indi.Locate('ID',ID,[]);
    Fami.Locate('ID',St,[]);
     If Fami.FieldByName('Hustru').AsString <> '' Then
    Begin

      Indi.Locate('ID',Fami.fieldbyname('Hustru').AsString,[]);
        If MedUdskrift Then
          DrawForeldre(Generation, nr*2, Fami.fieldbyname('Hustru').AsString);
        St :=  Indi.FieldByName('ForNavn').AsString+' '+Indi.FieldByName('Efternavn').AsString+' '+IntToStr(Generation)+' '+IntToStr(nr*2-1);
        MyNode := TV1.Items.AddChild(ThisNode,St);
        DanForeldre(Moder,Generation,nr*2,Fami.FieldByName('Hustru').AsString,MyNode);
     End;
  end;
end;

end.

