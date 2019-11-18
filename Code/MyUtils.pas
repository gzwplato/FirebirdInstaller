unit MyUtils;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, System.StrUtils, ShellAPI, Vcl.Forms,
  Arrays;

type

  TUtils = class
  public
    class function Iif(Cond: boolean; V1, V2: variant): variant;
    class function IfLess(Value, Value2: integer): integer;
    class function IfEmpty(Value, Replace: string): string;
    class function IfZero(Value, Replace: integer): integer;

    class function IifLess(Cond: boolean; V1, V2: integer): integer;
    class function IifEmpty(Cond: boolean; V1, V2: string): string;
    class function IifZero(Cond: boolean; V1, V2: integer): integer;

    class function Cut(Text, Separator: string): TStringArray;

    class function ArrayToStr(StrArray: TStringArray; Separator: string; StrFinal: string; Starts: integer = 0; EndsBefore: integer = 0): string; overload;
    class function ArrayToStr(StrArray: System.TArray<System.string>; Separator: string; StrFinal: string; Starts: integer = 0; EndsBefore: integer = 0): string; overload;

    class function Extract(StrList: TStringList; Starts, Ends: integer): TStringList; overload;
    class function Extract(StrList: TStringList; Starts, Ends: string; IncStarts: boolean = true; IncEnds: boolean = true): TStringList; overload;
    class function Extract(StrList: TStringList; Starts: integer; Ends: string; IncEnds: boolean = false): TStringList; overload;
    class function Extract(StrList: TStringList; Starts: string; Ends: integer; IncStarts: boolean = false): TStringList; overload;

    class procedure ExecCmd(Comand: string; ShowCmd: integer = 1);

    class function AppPath: string;
  end;

implementation

//M�todo para usar operador tern�rio
class function TUtils.Iif(Cond: boolean; V1, V2: variant): variant;
begin
  if Cond then
  begin
    Result := V1;
  end
  else
  begin
    Result := V2;
  end;
end;

//Retorna o menor valor
class function TUtils.IfLess(Value, Value2: integer): integer;
begin
  Result := Iif(Value < Value2, Value, Value2);
end;

//Retorna um substituto se o valor for vazio
class function TUtils.IfEmpty(Value, Replace: string): string;
begin
  Result := Iif(Value.Trim = '', Replace, Value);
end;

//Retorna um substituto se o valor for zero
class function TUtils.IfZero(Value, Replace: integer): integer;
begin
  Result := Iif(Value = 0, Replace, Value);
end;

//Iif e IfLess juntos num m�todo s�
class function TUtils.IifLess(Cond: boolean; V1, V2: integer): integer;
begin
  Result := Iif(Cond, V1, IfLess(V2, V1));
end;

//Iif e IfEmpty juntos num m�todo s�
class function TUtils.IifEmpty(Cond: boolean; V1, V2: string): string;
begin
  Result := Iif(Cond, V1, IfEmpty(V2, V1));
end;

//Iif e IfZero juntos num m�todo s�
class function TUtils.IifZero(Cond: boolean; V1, V2: integer): integer;
begin
  Result := Iif(Cond, V1, IfZero(V2, V1));
end;

//Divide uma string em array baseando-se no separador
class function TUtils.Cut(Text, Separator: string): TStringArray;
var
  StrArray: TStringDynArray;
  Cont: integer;
begin
  SetLength(StrArray, Length(SplitString(Text, Separator)));
  StrArray := SplitString(Text, Separator);
  SetLength(Result, Length(StrArray));
  for Cont := 0 to Length(StrArray) - 1 do
  begin
    Result[Cont] := StrArray[Cont];
  end;
end;

//Transforma um array em uma string
class function TUtils.ArrayToStr(StrArray: TStringArray; Separator, StrFinal: string; Starts: integer; EndsBefore: integer): string;
var
  Cont: integer;
begin
  Result := '';
  for Cont := TUtils.Iif(Starts >= Length(StrArray), 0, Starts) to Length(StrArray) - 1 - EndsBefore do
  begin
    if Cont = Length(StrArray) - 1 - EndsBefore then
    begin
      Result := Result + StrArray[Cont] + StrFinal;
    end
    else
    begin
      Result := Result + StrArray[Cont] + Separator;
    end;
  end;
end;

class function TUtils.ArrayToStr(StrArray: System.TArray<System.string>; Separator, StrFinal: string; Starts: integer; EndsBefore: integer): string;
var
  Cont: integer;
begin
  Result := '';
  for Cont := TUtils.Iif(Starts >= Length(StrArray), 0, Starts) to Length(StrArray) - 1 - EndsBefore do
  begin
    if Cont = Length(StrArray) - 1 - EndsBefore then
    begin
      Result := Result + StrArray[Cont] + StrFinal;
    end
    else
    begin
      Result := Result + StrArray[Cont] + Separator;
    end;
  end;
end;

//Extrai uma parte de uma StringList
class function TUtils.Extract(StrList: TStringList; Starts, Ends: integer): TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  Ends := IfLess(Ends + 1, StrList.Count);
  for Cont := Starts to Ends do
  begin
    Result.Add(StrList[Cont]);
  end;
end;

class function TUtils.Extract(StrList: TStringList; Starts, Ends: string; IncStarts: boolean; IncEnds: boolean): TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  Cont := 0;
  while StrList[Cont] <> Starts do
  begin
    Inc(Cont);
  end;

  for Cont := Iif(IncStarts, Cont, Cont + 1) to StrList.Count - 1 do
  begin
    if StrList[Cont] <> Ends then
    begin
      Result.Add(StrList[Cont]);
    end
    else
    begin
      if IncEnds then
      begin
        Result.Add(StrList[Cont]);
      end;
      Break;
    end;
  end;
end;

class function TUtils.Extract(StrList: TStringList; Starts: integer; Ends: string; IncEnds: boolean): TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  for Cont := 0 to StrList.Count - 1 do
  begin
    if StrList[Cont] <> Ends then
    begin
      Result.Add(StrList[Cont]);
    end
    else
    begin
      if IncEnds then
      begin
        Result.Add(StrList[Cont]);
      end;
      Break;
    end;
  end;
end;

class function TUtils.Extract(StrList: TStringList; Starts: string; Ends: integer; IncStarts: boolean): TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  Cont := 0;
  while StrList[Cont] <> Starts do
  begin
    Inc(Cont);
  end;

  for Cont := Iif(IncStarts, Cont, Cont + 1) to Ends do
  begin
    Result.Add(StrList[Cont]);
  end;
end;

class procedure TUtils.ExecCmd(Comand: string; ShowCmd: integer = 1);
begin
  ShellExecute(0, nil, 'cmd.exe', PWideChar(Comand), nil, ShowCmd);
end;

class function TUtils.AppPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

end.