{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit tvl;

interface

uses
  tvl_uapplaunch, tvl_udatabinder, tvl_udatabinders, tvl_ibindings, 
  tvl_ubehavebinder, tvl_ubehavebinders, tvl_ugridbinders, tvl_utallybinders, 
  tvl_messages, tvl_iedit, tvl_ucontrolbinder, tvl_SimpleListForm, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('tvl', @Register);
end.
