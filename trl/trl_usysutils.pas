unit trl_usysutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_isysutils, base64;

type

  { TSysUtils }

  TSysUtils = class(TInterfacedObject, ISysUtils)
  protected
    // ISysUtils
    function NewGID: string;
    function NewGuid: TGuid;
  end;

implementation

{ TSysUtils }

function TSysUtils.NewGID: string;
var
  mGuid: TGuid;
  mEncStream: TBase64EncodingStream;
  mStrStream: TStringStream;
begin
  mGuid := NewGuid;
  mStrStream := TStringStream.Create;
  try
    mEncStream := TBase64EncodingStream.Create(mStrStream);
    try
      mEncStream.Write(mGuid, SizeOf(mGuid));
    finally
      mEncStream.Free;
    end;
    Result := mStrStream.DataString;
    while Result[Length(Result)] = '=' do
      Delete(Result, Length(Result), 1);
  finally
    mStrStream.Free;
  end;
end;

function TSysUtils.NewGuid: TGuid;
begin
  CreateGUID(Result);
end;

end.

