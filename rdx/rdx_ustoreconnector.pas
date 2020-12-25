unit rdx_ustoreconnector;

{$mode objfpc}{$H+}

interface

uses
  trl_igenericaccess, trl_itree, flu_iflux, sysutils, trl_iprops,
  trl_idifactory;

type

  { TRdxStoreConnector }

  TRdxStoreConnector = class(TInterfacedObject, IFluxStoreConnector, IFluxData)
  protected
    // IFluxData
    function Exists(const AKey: string): Boolean;
    function GetData(const AKey: string): IGenericAccess;
  protected
    fStore: IFluxData;
  published
    property Store: IFluxData read fStore write fStore;
  end;

implementation

{ TRdxStoreConnector }

function TRdxStoreConnector.Exists(const AKey: string): Boolean;
begin
  Result := Store.Exists(AKey);
end;

function TRdxStoreConnector.GetData(const AKey: string): IGenericAccess;
begin
  Result := Store[AKey];
end;

end.

