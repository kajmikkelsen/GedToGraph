unit UVis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, ATImageBox, MyLib;

type

  { TFVis }

  TFVis = class(TForm)
    AI1: TATImageBox;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    BFit: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure BFitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private

  public

  end;

var
  FVis: TFVis;

implementation
 Uses
   UPersonliste;
{$R *.lfm}

{ TFVis }

procedure TFVis.FormCreate(Sender: TObject);
begin
  RestoreForm(FVis);
  SetPixelsPrMM(True);
  With Ai1 do
  Begin
    image.Height := mmtopix(297);
    image.Width:= mmtopix(210);
    image.Picture.Bitmap.Width := mmtopix(210);
    image.Picture.Bitmap.Height := mmtopix(297);
    image.Canvas.pen.Color:=clBlack;
    image.Canvas.Brush.Color:= clWhite;
    image.Canvas.FillRect(0,0,image.Canvas.Width-1,image.Canvas.Height-1);
    image.Canvas.FillRect(0,0,image.Canvas.Width-1,image.Canvas.Height-1);
  End;
end;

procedure TFVis.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFVis.Button1Click(Sender: TObject);
begin

With FVis.AI1 Do
Begin
end;


  AI1.Canvas.Pen.Color := clBlack;;
  AI1.UpdateInfo;
end;

procedure TFVis.BFitClick(Sender: TObject);
begin
  AI1.OptFitToWindow:= Not AI1.OptFitToWindow ;
end;

procedure TFVis.FormDestroy(Sender: TObject);
begin
  SaveForm(FVis);
end;

procedure TFVis.ToolButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFVis.ToolButton2Click(Sender: TObject);
begin
  AI1.ImageZoom:=AI1.ImageZoom+10;
end;

procedure TFVis.ToolButton3Click(Sender: TObject);
begin
  AI1.ImageZoom:=AI1.ImageZoom-10;
end;

end.

