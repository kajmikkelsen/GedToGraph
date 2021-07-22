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
  ComCtrls, PrintersDlgs, Printers,LazUTF8,UGedText,LConvEncoding;

type

  { TFPersonliste }

  TFPersonliste = class(TForm)
    BCreatTree: TButton;
    BFont: TButton;
    Button1: TButton;
    CBAne: TCheckBox;
    CVielse: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    EUdskriver: TEdit;
    EOverskrift: TEdit;
    FD1: TFontDialog;
    AfslutButton: TButton;
    Label1: TLabel;
    Indi: TMemDataset;
    Fami: TMemDataset;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SG1DblClick(Sender: TObject);
    procedure SG1HeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer
      );
    procedure SG1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    AneNummer: Integer;
    SlutY,x1,x2,x3,x4,x5,x6,X7,y0,y1,y2,y3,y4,y5,y6,y7,offset:Real;

    Forhold: Real;
    MedUdskrift,FontValgt: Boolean;
    LC,Margininpix: Integer;
    Procedure DanForeldre(Generation,nr:Integer;ID:String;ThisNode: TTreeNode);
    Procedure SetHeader;
    Procedure DrawForeldre(MyCanvas:Tcanvas;Gen,nr:Integer;ID,GDato:String);
    Procedure ReadFromList(Var St:String);
    procedure DrawProband(MyCanvas:TCanvas;MyPenWidth: Integer);
  public
    FileName: String;
    DoIndles,Vis: Boolean;
    Margin: Integer;
    Procedure IndLes;
    Procedure DrawTemplate(MyCanvas: TCanvas;MyPenWidth: Integer);
    Function TransDate(St:String): String;
  end;

  Const
    MaxTrans = 16;
    TransSt: Array [0 .. MaxTrans] of String = (
    'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC','BEF','AFT','BET','AND','ABT');
    TransSt1: Array[0 .. MaxTrans] of string = (
    '01','02','03','04','05','06','07','08','09','10','11','12','Før','Efter','Mellem','og','Omkring');
var
  FPersonliste: TFPersonliste;

implementation
Uses
    MyLib,UGlobal,UVis,Math;
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
  SG2.Cells[4,0] := 'G. Dato';
End;

procedure TFPersonliste.DrawTemplate(MyCanvas: TCanvas;MyPenWidth: Integer);
Var
  x,y,tw,i,i1,i2: Integer;
  St,st1: String;
begin
  myCanvas.Pen.Width:= MyPenWidth;
  myCanvas.Pen.Color := clBlack;
  MyCanvas.Brush.Color := clWhite;
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

  i := MyCanvas.font.size;
  mycanvas.font.size := 12;
  myCanvas.font.Orientation := 0;
  St := EOverskrift.Text;
  I1 := Pos('*',St);
  If i1 > 0 Then
  Begin
    St1 := GetFieldByDelimiter(0,st,'*')+' '+Edit1.Text+' '+GetFieldByDelimiter(1,st,'*');
  end
  Else
    St1 := St;
  tw := MyCanvas.TextWidth(St1);
  x := Trunc(rmmtopix(x6-Margin/ 2)-(tw/2))-mmtopix(Margin);
  i1 := Mycanvas.font.Height*2;
  y := rmmtopix(Margin)+I1;
  myCanvas.TextOut(x,y,st1);

  mycanvas.font.size := 6;
  St := EUdskriver.text;
  tw := MyCanvas.TextWidth(St);
  x := rmmtopix(X1);
  y := rmmtopix(y6)+mmtopix(1);
  myCanvas.TextOut(x,y,st);


  St := DateTimeToStr(Now);
  tw := MyCanvas.TextWidth(St);
  x := rmmtopix(X1);
  y := rmmtopix(y6)+mmtopix(1)-MyCanvas.Font.Height+rmmtopix(0.5);
  myCanvas.TextOut(x,y,st);

  St := Filename;
  tw := MyCanvas.TextWidth(St);
  x := rmmtopix(X1);
  y := rmmtopix(y6)+mmtopix(1)-MyCanvas.Font.Height*2+rmmtopix(1);
  myCanvas.TextOut(x,y,st);
  MyCanvas.Font.Size := i;


  myCanvas.Rectangle(rmmtopix(x1),rmmtopix(y0),rmmToPix(x7),Trunc(Sluty));
  DrawLine(myCanvas,X2,Margin,X2,y6);
  DrawLine(myCanvas,X3,Margin,x3,y6);
  DrawLine(myCanvas,X4,Margin,X4,y6);
  DrawLine(myCanvas,X5,Margin,X5,y6);
  DrawLine(myCanvas,X6,Margin,X6,y6);

  If CVielse.Checked Then
    I2 := 5
  Else
    I2 := 0;
  DrawLine(myCanvas,X2+i2,Margin+Y1,X7,Margin+Y1);

  DrawLine(myCanvas,X3+i2,Margin+Y2,X7,Margin+Y2);
  DrawLine(myCanvas,X3+i2,Margin+Y2*3,X7,Margin+Y2*3);

  DrawLine(myCanvas,x4+i2,Margin+y3,X7,Margin+y3);
  DrawLine(myCanvas,X4+i2 ,Margin+y3*3,X7,Margin+y3*3);
  DrawLine(myCanvas,X4+i2,Margin+y3*5,X7,Margin+y3*5);
  DrawLine(myCanvas,X4+i2,Margin+y3*7,X7,Margin+y3*7);

  DrawLine(myCanvas,X5+i2,Margin+y4,X7,Margin+y4);
  DrawLine(myCanvas,X5+i2,Margin+y4*3,X7,Margin+y4*3);
  DrawLine(myCanvas,X5+i2,Margin+y4*5,X7,Margin+y4*5);
  DrawLine(myCanvas,X5+i2,Margin+y4*7,X7,Margin+y4*7);
  DrawLine(myCanvas,X5+i2,Margin+y4*9,X7,Margin+y4*9);
  DrawLine(myCanvas,X5+i2,Margin+y4*11,X7,Margin+y4*11);
  DrawLine(myCanvas,X5+i2,Margin+y4*13,X7,Margin+y4*13);
  DrawLine(myCanvas,X5+i2,Margin+y4*15,X7,Margin+y4*15);

  DrawLine(myCanvas,X6+i2*2,Margin+y5,X7,Margin+y5);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*3,X7,Margin+y5*3);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*5,X7,Margin+y5*5);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*7,X7,Margin+y5*7);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*9,X7,Margin+y5*9);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*11,X7,Margin+y5*11);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*13,X7,Margin+y5*13);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*15,X7,Margin+y5*15);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*17,X7,Margin+y5*17);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*19,X7,Margin+y5*19);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*21,X7,Margin+y5*21);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*23,X7,Margin+y5*23);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*25,X7,Margin+y5*25);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*27,X7,Margin+y5*27);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*29,X7,Margin+y5*29);
  DrawLine(myCanvas,X6+i2*2,Margin+y5*31,X7,Margin+y5*31);

end;

function TFPersonliste.TransDate(St: String): String;
Var
  i,i1:Integer;
  St1: String;
begin
  If Pos(' ',St) = 2 Then St := '0'+St;
  If St[6] = ' ' Then
    St := Copy(St,1,4)+'0'+Copy(St,5,Length(St));
  i1 := Pos('AND ',St);
  IF St[i1+5] = ' ' Then
    St := Copy(St,1,i1+3)+'0'+Copy(St,i1+4,Length(St));
  For I1 := 0 to 1 Do
  Begin
    For i := 0 To MaxTrans Do
    Begin
      If i < 12 Then
        St := StringReplace(St,TransSt[i],'-'+TransSt1[i]+'-',[])
      Else
        St := StringReplace(St,TransSt[i],TransSt1[i],[]);
    end;
    St := StringReplace(St,' -','-',[]);
    St := StringReplace(St,'- ','-',[]);
  end;
  If St[1] = '-' Then Delete(St,1,1);
  I1  := Pos('Før-',St);
  If I1 > 0 Then
    St[5] := ' ';
  I1  := Pos('Efter-',St);
  If I1 > 0 Then
    St[6] := ' ';
  I1  := Pos('Omkring-',St);
  If I1 > 0 Then
    St[8] := ' ';
  I1  := Pos('m-',St);
  If I1 > 0 Then
    St[7] := ' ';
  I1  := Pos('og-',St);
  If I1 > 0 Then
    St[I1+2] := ' ';
  TransDate := st;
end;

procedure TFPersonliste.DrawForeldre(MyCanvas: Tcanvas; Gen, nr: Integer; ID,
  GDato: String);
var
  x,y:Real;
  tw,Xx,Yy,Xx1,Yy1,Xx2,Yy2,Yoffset,XOffset: Integer;
  St1,St2,St3,St4: STring;
  Found: Boolean;

begin
  {$IFDEF windows }
  YOffset := 1;
  Xoffset := 0;
  {$ENDIF }
  {$IFDEF linux}
  YOffset := 1;
  If MedUdskrift Then
    Xoffset := -MyCanvas.Font.Height
  Else
    XOffset := 0;
  {$ENDIF}

  Anenummer := StrToInt(Edit2.Text);
  AneNummer := 2**(Gen-1)*anenummer+nr-1;
  Found := Indi.Locate('ID',ID,[]);
  If Found Then
  Begin
    Case Gen of
      2: Begin
          St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
          St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
          MyCanvas.Font.Orientation := 2700;
          tw := MyCanvas.TextWidth(St1);
          Xx1 := rmmtopix(x2)-MyCanvas.Font.Height*2+Trunc(Offset)+rmmtopix(0.5);
          Yy1 := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y1+(y1/2))-(tw/2));
          MyCanvas.textout(Xx1,Yy1,st1);
          tw := MyCanvas.TextWidth(St2);
          Xx2 := rmmToPix(x2)-MyCanvas.font.height+Trunc(Offset);
          Yy2 := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y1+(y1/2))-(tw/2));
          MyCanvas.textout(Xx2,Yy2,st2);
          Xx := Xx1-MyCanvas.Font.Height-mmtopix(1);
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y1)+Canvas.TextWidth('1')+mmtopix(YOffset));
          If CBAne.Checked Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
          If CVielse.Checked And ((Nr mod 2) = 0) Then
          Begin
            Xx := Xx2+MyCanvas.Font.Height;
            Yy := Trunc(rmmtopix(Margin+y1)) -  MyCanvas.TextWidth(GDato)div 2 ;
            MyCanvas.TextOut(Xx,Yy,Gdato);
          End;
      end;
      3:Begin
        St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
        St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
        MyCanvas.Font.Orientation := 2700;
        tw := MyCanvas.TextWidth(St1);
        Xx1 := Trunc(rmmToPix(x3)-MyCanvas.font.height*2+Offset+rmmtopix(0.5)+Xoffset);
        Yy1 := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y2+(y2/2))-(tw/2));
        MyCanvas.textout(Xx1,Yy1,st1);
        tw := MyCanvas.TextWidth(St2);
        Xx2 := Trunc(rmmToPix(x3)-MyCanvas.font.height+Offset)+XOffset;
        Yy2:= Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y2+(y2/2))-(tw/2));
        MyCanvas.textout(xx2,Yy2,st2);
        Xx := Trunc(Xx1-(MyCanvas.Font.Height)+Offset+Xoffset);
        Yy := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y2)+Canvas.TextWidth('1'))+mmtopix(YOffset);
        If CBAne.Checked Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
        If CVielse.Checked  And ((Nr mod 2) = 0) Then
        Begin
          Xx := Xx2+MyCanvas.Font.Height-Xoffset;
          tw := MyCanvas.TextWidth(Gdato);
//          Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr+2) div 2)-1)*y1+(y1/2))-(tw/2));
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr) div 2)-1)*y1+(y1/2))-(tw/2));
          MyCanvas.TextOut(Xx,Yy,Gdato);
        End;
      end;
      4:Begin
          St1 := Indi.FieldByName('Fornavn').AsString;
          St2 := Indi.FieldByName('Efternavn').AsString;
          St3 := Indi.FieldByName('FodDato').AsString;
          St4 := Indi.FieldByName('DodDato').AsString;
          MyCanvas.Font.Orientation := 2700;
          tw := MyCanvas.TextWidth(St1);
          x := rmmToPix(x4)-MyCanvas.font.height*5+Offset+rmmtopix(1.5);
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          MyCanvas.textout(Trunc(x),Trunc(y),st1);
          tw := MyCanvas.TextWidth(St2);
          Xx1 := Trunc(rmmToPix(x4)-MyCanvas.font.height*4+Offset+rmmtopix(1));
          Yy1:= Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2));
          MyCanvas.textout(Xx1,Yy1,st2);
          tw := MyCanvas.TextWidth(St3);
          Xx2 := Trunc(rmmToPix(x4)-MyCanvas.font.height*3+Offset+rmmtopix(0.5));
          Yy2:= Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2));
          MyCanvas.textout(Xx2,Yy2,st3);
          tw := MyCanvas.TextWidth(St4);
          x := rmmToPix(x4)-MyCanvas.font.height*2+Offset;
          y:= rmmtopix(Margin)+rmmtopix((Nr-1)*y3+(y3/2))-(tw/2);
          MyCanvas.textout(Trunc(x),Trunc(y),st4);
          Xx := Trunc(Xx1+Offset)+2*XOffset;
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((Nr-1)*y3)+Canvas.TextWidth('1')+mmtopix(YOffset));
          If CBAne.Checked Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
          If CVielse.Checked  And ((Nr mod 2) = 0)Then
          Begin
            Xx := Trunc(X)+MyCanvas.Font.Height*2;
            tw := MyCanvas.TextWidth(Gdato);
//            Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr+2) div 2)-1)*y2+(y2/2))-(tw/2));
            Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr) div 2)-1)*y2+(y2/2))-(tw/2));
            MyCanvas.TextOut(Xx,Yy,Gdato);
          End;

      end;
      5:Begin
        St1 := Indi.FieldByName('Fornavn').AsString;
        St2 := Indi.FieldByName('Efternavn').AsString;
        St3 := Indi.FieldByName('FodDato').AsString;
        St4 := Indi.FieldByName('DodDato').AsString;
        MyCanvas.Font.Orientation := 0;
        tw := MyCanvas.TextWidth(St1);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y4)-MyCanvas.font.Height*1-rmmtopix(1.5);
        MyCanvas.textout(Trunc(x),Trunc(y),st1);
        tw := MyCanvas.TextWidth(St2);
        Xx1 := Trunc(rmmtopix(x5+(x6-x5)/ 2) -(tw/2));
        Yy1 := Trunc(rmmtopix(Margin)+rmmtopix((nr-1)*y4)-MyCanvas.font.Height*2+rmmtopix(0.5)-rmmtopix(1.5));
        MyCanvas.textout(Xx1,Yy1,st2);
        tw := MyCanvas.TextWidth(St3);
        Xx2 := Trunc(rmmtopix(x5+(x6-x5)/ 2) -(tw/2));
        Yy2 := Trunc(rmmtopix(Margin)+rmmtopix((nr-1)*y4)-MyCanvas.font.Height*3+mmtopix(1)-rmmtopix(1.5));
        MyCanvas.textout(Xx2,Yy2,st3);
        tw := MyCanvas.TextWidth(St4);
        x := rmmtopix(x5+(x6-x5)/ 2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y4)-MyCanvas.font.Height*4+rmmtopix(1.5)-rmmtopix(1.5);
        MyCanvas.textout(Trunc(x),Trunc(y),st4);
//        Xx := Trunc(rmmtopix(x5)+rmmtopix(1));
        If CVielse.Checked Then
          Xx := Trunc(rmmtopix(x5)+rmmtopix(2))-MyCanvas.Font.Height
        Else
          Xx := Trunc(rmmtopix(x5)+rmmtopix(1));
        Yy := Trunc(rmmtopix(Margin)+rmmtopix((nr-1)*y4)-MyCanvas.font.Height*1-rmmtopix(1.5));
        If CBAne.Checked Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
        If CVielse.Checked  And ((Nr mod 2) = 0)Then
        Begin
          MyCanvas.Font.Orientation := 2700;
          Xx := rmmtopix(x5)-MyCanvas.Font.Height + rmmtopix(1.5)-Xoffset*2;
          tw := MyCanvas.TextWidth(Gdato);
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr+1) div 2)-1)*y3+(y3/2))-(tw/2));
          MyCanvas.TextOut(Xx,Yy,Gdato);
        End;

      end;
      6:Begin
        St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
        St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
        MyCanvas.Font.Orientation := 0;
        tw := MyCanvas.TextWidth(St1);
        x := rmmtopix(x6+(x7-x6)/2) -(tw/2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y5)+rmmtopix(y7);
        MyCanvas.textout(Trunc(x),Trunc(y),st1);
        tw := MyCanvas.TextWidth(St2);
        y := rmmtopix(Margin)+rmmtopix((nr-1)*y5)+rmmtopix(y7)-MyCanvas.font.Height+rmmtopix(0.5);
        x := rmmtopix(x6+(x7-x6)/2) -(tw/2);
        MyCanvas.textout(Trunc(x),Trunc(y),st2);
//        Xx := Trunc(rmmtopix(x5+(x6-x5))+mmtopix(1));
        If CVielse.Checked Then
          Xx := Trunc(rmmtopix(x5+(x6-x5))-MyCanvas.font.Height*2+mmtopix(2))
        Else
          Xx := Trunc(rmmtopix(x5+(x6-x5))+mmtopix(1));
        Yy := Trunc(rmmtopix(Margin)+rmmtopix((nr-1)*y5)+rmmtopix(y7));
        If CBAne.Checked Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
        If CVielse.Checked  And ((Nr mod 2) = 0) Then
        Begin
          St1 := GetFieldByDelimiter(0,gdato,'-')+'-'+GetFieldByDelimiter(1,gdato,'-');
          St2 := GetFieldByDelimiter(2,gdato,'-');
          If St1 = '-' Then St1 := '';
          If St2 = '' Then
          Begin
            St2 := St1;
            St1 := '';
          end;
          MyCanvas.Font.Orientation := 2700;
          Xx := rmmtopix(x6)-MyCanvas.Font.Height*2 + rmmtopix(2)-Xoffset*2;
          tw := MyCanvas.TextWidth(St1);
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr+1) div 2)-1)*y4+(y4/2))-(tw/2));
          MyCanvas.TextOut(Xx,Yy,St1);
          Xx := rmmtopix(x6)-MyCanvas.Font.Height + rmmtopix(1.5)-Xoffset*2;
          tw := MyCanvas.TextWidth(St2);
          Yy := Trunc(rmmtopix(Margin)+rmmtopix((((Nr+1) div 2)-1)*y4+(y4/2))-(tw/2));
          MyCanvas.TextOut(Xx,Yy,St2);

        end;

      end;
      7: Begin
          MyCanvas.Font.Orientation := 0;
           x := rmmtopix(x7)-rmmtopix(2);
           y := rmmtopix(Margin)+rmmtopix((nr-1)*y5/2)+rmmtopix(y7);
           MyCanvas.textout(Trunc(x),Trunc(y),'+');
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
  I,i1,i2,i3,i4: Integer;
  Slut,UTF,BE: Boolean;
  SaveCursor: Tcursor;
  FamNo: String;
  MS: TMemoryStream;
  BOM: Array[1..3] of byte;
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
  BE := False;
  If (BOM[1]=255) and (BOM[2] = 254) Then UTF := True;
  If (BOM[1]=254) and (BOM[2] = 255) Then
  Begin
    UTF := True;
    BE := True;
  end;
  {$ENDIF}
  MyLines := TStringList.Create;
  If UTF Then
  Begin
    IF BE then
    Begin
    AssignFile(fl1,FileName);
    SetTextCodePage(fl1,cp_UTF16BE);
    Reset(fl1);
    While Not Eof(Fl1) Do
    Begin
      Readln(fl1,St);
      Delete(St,Length(st),1);
      If Length(St) > 2 Then
        MyLines.Add(St);
    end;
    CloseFile(Fl1);
    End
    Else
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
    End;
  End
  Else
    MyLines.LoadFromFile(FileName);
  For i4 := 0 to Mylines.Count -1 Do
  Begin
    If (GuessEncoding(MyLines[i4])  = 'ISO-8859-1') or
       (GuessEncoding(MyLines[i4])  = 'cp1252')
    Then
      MyLines[i4] := CP1252ToUTF8(MyLines[i4]);
  End;
  While Not Slut Do
  Begin
    ReadFromList(St);
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
                If Pos('TYPE',St) = 3 Then
                  ReadFromList(St);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[4,i-1] := TransDate(Copy(St,8,Length(St)-7));
              end;
              If Pos('DEAT',St) = 3 Then
              Begin
                ReadFromList(St);
                If Pos('TYPE',St) = 3 Then
                  ReadFromList(St);
                if pos('DATE',st) = 3 Then
                  SG1.Cells[5,i-1] := TransDate(Copy(St,8,Length(St)-7));
              end;
              If Pos('FAMC',St) = 3 Then
              Begin
                FamNo := GetFieldByDelimiter(1,St,'@');
                ReadFromList(St);
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
              If Pos('MARR',St) = 3 Then
              Begin
                ReadFromList(St);
                If Pos('TYPE',St) = 3 Then
                  ReadFromList(St);
                If Pos('DATE',St) = 3 Then
                  SG2.Cells[4,i1-1] := TransDate(Copy(St,8,Length(St)-7))
                Else
                  SG2.Cells[4,i1-1] := ' ';
                If Pos('0',St) = 1 Then
                Dec(lc);
              end;
            end
            else
              Slut := True;
          end;
        end
        Else
        Begin
          ReadFromList(St);
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
      Fami.FieldByName('GiftDato').AsString := SG2.Cells[4,i];
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
  St := GetStdIni('Misc','Anenumre','True');
  If St = 'True' Then
    CBAne.Checked := True
  Else
    CBAne.Checked := False;
  St := GetStdIni('Misc','MedVielse','True');
  If St = 'True' Then
    CVielse.Checked := True
  Else
    CVielse.Checked := False;
  St := GetStdIni('Font','Name','None');
  If St <> 'None' Then
  Begin
    FD1.Font.Name := St;
    FD1.Font.Size := StrToInt(GetStdIni('Font','Size','8'));
    FD1.Font.Height := StrToInt(GetStdIni('Font','Height','-11'));
  end;
  EOverskrift.Text := GetSTdIni('StdTekster','overskrift','');
  EUdskriver.Text := GetStdIni('StdTekster','udskriver','');
  Vis := False;
end;


procedure TFPersonliste.AfslutButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFPersonliste.BCreatTreeClick(Sender: TObject);
Var
  MyNode: TTreeNode;
  St1: STring;

begin
  PutSTdIni('StdTekster','overskrift',EOverskrift.Text);
  PutStdIni('StdTekster','udskriver',EUdskriver.Text);

  TV1.Items.Clear;
  If FokusPerson = '' Then
    Showmessage('Vælg fokusperson ved at klikke på personen i listen')
  Else
  Begin
    MedUdskrift := True;
    If MedUdskrift Then
      If Not PD1.Execute Then Exit;
    Indi.Locate('ID',FokusPerson,[]);
    MyNode := TV1.Items.Add(nil,Indi.FieldByName('Fornavn').AsString+' '+Indi.FieldByName('EfterNavn').AsString+' 1');
    If MedUdskrift Then
    Begin
      With Printer do
      Try

        BeginDoc;

        St1 := GetStdIni('Font','Name','None');
        If ST1 <> 'None' Then
        Begin
          Printer.Canvas.font.name := St1;
          Printer.Canvas.Font.Height := StrToInt(GetStdIni('Font','Height','-11'));
          Printer.Canvas.font.size := StrToInt(GetStdIni('Font','Size','8'));
        end;
        SetPixelsPrmm(false);
        Margininpix := mmtopix(Margin);
        DrawTemplate(Canvas,5);
        DrawProband(Printer.Canvas,5);
        DanForeldre(1,1,Indi.FieldByName('ID').AsString,MyNode);
      finally
        EndDoc
      end;
    End
    Else
    Begin
      DanForeldre(1,1,Indi.FieldByName('ID').AsString,MyNode);
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
    PutStdIni('Font','Height',IntToStr(FD1.Font.Height));
  end;
end;

procedure TFPersonliste.Button1Click(Sender: TObject);
Var
  MyNode: TTreeNode;
begin
  MedUdskrift := False;
  Vis := True;
  AneNummer := StrToInt(Edit2.text);
  SetPixelsPrMM(True);
  FPersonliste.DrawTemplate(FVis.AI1.Image.Canvas,2);
  Indi.Locate('ID',FokusPerson,[]);
  MyNode := TV1.Items.Add(nil,Indi.FieldByName('Fornavn').AsString+' '+Indi.FieldByName('EfterNavn').AsString+' 1');
  DrawProband(FVIs.Ai1.image.Canvas,2);
  DanForeldre(1,1,Indi.FieldByName('ID').AsString,MyNode);

  FVis.Ai1.UpdateInfo;
  FVis.SHow;
  Vis := False;

end;

procedure TFPersonliste.FormDestroy(Sender: TObject);
begin
  SaveGridCols(SG1,'personliste');
  SaveGridCols(SG2,'familieliste');
  If CBAne.Checked Then
    PutStdIni('Misc','Anenumre','True')
  Else
    PutStdIni('Misc','Anenumre','False');
  If CVielse.Checked Then
    PutStdIni('Misc','MedVielse','True')
  Else
    PutStdIni('Misc','MedVielse','False');


  SaveForm(FPersonListe);
end;

procedure TFPersonliste.FormShow(Sender: TObject);
begin
  If DoIndles Then Indles;
end;

procedure TFPersonliste.SG1DblClick(Sender: TObject);
begin
  BCreatTreeClick(Sender);
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

procedure TFPersonliste.DrawProband(MyCanvas: TCanvas; MyPenWidth: Integer);
Var
  St1,St2:String;
  Xx,Yy,Xx1,Xx2,Yy1,Yy2,TWidth:Integer;

begin
  St1 := GetStdIni('Font','Name','None');
  AneNummer := StrToInt(Edit2.Text);
  If ST1 <> 'None' Then
  Begin
    MyCanvas.font.name := St1;
    MyCanvas.Font.Height := StrToInt(GetStdIni('Font','Height','-11'));
    MyCanvas.font.size := StrToInt(GetStdIni('Font','Size','8'));
  end
  else
    MyCanvas.Font.Size := 8;



  St1 := Indi.FieldByName('Fornavn').AsString + ' ' + Indi.FieldByName('EfterNavn').AsString;
  St2 := Indi.FieldByName('FodDato').AsString + ' - ' + Indi.FieldByName('DodDato').AsString;
  MyCanvas.Font.Color := clBlack;
  TWidth := Mycanvas.TextWidth(St1);
  {$IFDEF windows }
  Offset := -(Trunc(Mycanvas.font.Height*1.5));
  {$ENDIF }
  {$IFDEF linux}
  If Vis Then
    Offset := -(Trunc(Mycanvas.font.Height*1.5))
  else
    Offset := (Trunc(Mycanvas.font.Height*0.5));
  {$ENDIF}
  MyCanvas.Font.Orientation:= 2700;
  Fvis.Ai1.Image.Canvas.Font.Orientation:= 2700;
  Xx1 := Trunc(rmmtopix(X1))-Mycanvas.font.Height+rmmtopix(0.5)+Trunc(offset);
  Yy1 := Trunc(rmmtopix(Margin+y1)) - TWidth div 2 ;
  MyCanvas.TextOut(Xx1,Yy1, St1);
  TWidth := Mycanvas.TextWidth(St2);
  Xx2 := Trunc(rmmtopix(X1))+Trunc(Offset);
  Yy2 := Trunc(rmmtopix(Margin+y1)-TWidth/2);
  MyCanvas.TextOut(Xx2,Yy2 , St2);
  If MyCanvas.TextWidth(st1) > MyCanvas.TextWidth(St2) Then
    Yy := Yy1-MyCanvas.TextWidth(IntToStr(AneNummer)+': ')
  Else
    Yy := Yy2-MyCanvas.TextWidth(IntToStr(AneNummer)+': ');
  Xx := Xx2 + (Xx1-Xx2) Div 2;
  Xx := Xx1;
  Yy := Trunc(rmmtopix(y0)+mmtopix(2));
  If CBAne.Checked = True Then MyCanvas.TextOut(Xx,Yy,IntToStr(AneNummer));
end;

procedure TFPersonliste.DanForeldre(Generation,nr:Integer;ID:String; ThisNode: TTreeNode);
Var
  MyNode: TTreeNode;
  St:String;
begin
  Application.ProcessMessages;
  Inc(Generation);
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
          DrawForeldre(Printer.Canvas,Generation, nr*2-1, Fami.FieldByName('Mand').AsString, Fami.FieldByName('GiftDato').Asstring);
        If Vis Then
          DrawForeldre(FVis.ai1.image.Canvas,Generation, nr*2-1, Fami.FieldByName('Mand').AsString,Fami.FieldByName('GiftDato').Asstring);
        Indi.Locate('ID',Fami.fieldbyname('Mand').AsString,[]);
        MyNode := TV1.Items.AddChild(ThisNode,Indi.FieldByName('ForNavn').AsString+' '+Indi.FieldByName('Efternavn').AsString+' '+IntToStr(Generation)+' '+IntToStr(nr*2-1));
        DanForeldre(Generation,nr*2-1,Fami.fieldbyname('Mand').AsString,MyNode);
     End;
    Indi.Locate('ID',ID,[]);
    Fami.Locate('ID',St,[]);
     If Fami.FieldByName('Hustru').AsString <> '' Then
    Begin

      Indi.Locate('ID',Fami.fieldbyname('Hustru').AsString,[]);
        If MedUdskrift Then
          DrawForeldre(Printer.Canvas,Generation, nr*2, Fami.fieldbyname('Hustru').AsString,Fami.FieldByName('GiftDato').Asstring);
        If Vis Then
          DrawForeldre(FVis.Ai1.Image.Canvas,Generation, nr*2, Fami.fieldbyname('Hustru').AsString,Fami.FieldByName('GiftDato').Asstring);

        St :=  Indi.FieldByName('ForNavn').AsString+' '+Indi.FieldByName('Efternavn').AsString+' '+IntToStr(Generation)+' '+IntToStr(nr*2-1);
        MyNode := TV1.Items.AddChild(ThisNode,St);
        DanForeldre(Generation,nr*2,Fami.FieldByName('Hustru').AsString,MyNode);
     End;
  end;
end;

end.

