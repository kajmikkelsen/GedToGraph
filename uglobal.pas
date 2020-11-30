// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"

unit UGlobal;

{$mode objfpc}{$H+}
// Global Variables
interface
  uses
    Classes, SysUtils;
Type
  TPerson = Record
    ID,Fornavn,Efternavn,Fodselsdato,Dodsdato,familie: String;
  End;
  TFamilie = Record
    ID, Fader, Moder, Barn: STring;
  End;

  Var
    FokusPerson: String;
    MyLines: TStringList;

implementation

end.

