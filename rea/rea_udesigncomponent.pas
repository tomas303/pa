unit rea_udesigncomponent;

{$mode objfpc}{$H+}

interface

uses
  rea_idesigncomponent, trl_usystem, trl_imetaelement, rea_ireact, trl_imetaelementfactory,
  trl_iprops, rea_ibits, trl_itree, trl_idifactory, flu_iflux, trl_ilog;

type

  { TDesignComponent }

  TDesignComponent = class(TDynaObject, IDesignComponent)
  protected
    function NewProps: IProps;
    function NewNotifier(const AActionID: integer): IFluxNotifier;
  protected
    function DoCompose(const AParentElement: IMetaElement): IMetaElement; virtual; abstract;
  protected
    // IDesignComponent = interface
    function Compose(const AParentElement: IMetaElement): IMetaElement;
  protected
    fLog: ILog;
    fElementFactory: IMetaElementFactory;
    fFactory: IDIFactory;
  published
    property Log: ILog read fLog write fLog;
    property ElementFactory: IMetaElementFactory read fElementFactory write fElementFactory;
    property Factory: IDIFactory read fFactory write fFactory;
  end;

  { TDesignComponentForm }

  TDesignComponentForm = class(TDesignComponent, IDesignComponentForm)
  protected
    function DoCompose(const AParentElement: IMetaElement): IMetaElement; override;
  end;

  { TDesignComponentEdit }

  TDesignComponentEdit = class(TDesignComponent, IDesignComponentEdit)
  protected
    function DoCompose(const AParentElement: IMetaElement): IMetaElement; override;
  end;

  { TDesignComponentButton }

  TDesignComponentButton = class(TDesignComponent, IDesignComponentButton)
  protected
    function DoCompose(const AParentElement: IMetaElement): IMetaElement; override;
  end;

  { TDesignComponentHeader }

  TDesignComponentHeader = class(TDesignComponent, IDesignComponentHeader)
  protected
    function DoCompose(const AParentElement: IMetaElement): IMetaElement; override;
  end;


implementation

{ TDesignComponentHeader }

function TDesignComponentHeader.DoCompose(const AParentElement: IMetaElement
  ): IMetaElement;
var
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Layout, cProps.Place, cProps.Title, cProps.MMWidth, cProps.MMHeight,
    cProps.Border, cProps.BorderColor, cProps.FontColor, cProps.Transparent]);
  Result := ElementFactory.CreateElement(IStripBit, mProps);
end;

{ TDesignComponentButton }

function TDesignComponentButton.DoCompose(const AParentElement: IMetaElement
  ): IMetaElement;
var
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Place, cProps.MMWidth, cProps.MMHeight, cProps.Color, cProps.Text, cProps.ClickNotifier]);
  Result := ElementFactory.CreateElement(IButtonBit, mProps);
end;

{ TDesignComponentEdit }

function TDesignComponentEdit.DoCompose(const AParentElement: IMetaElement
  ): IMetaElement;
var
  mTitle: IProp;
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Place, cProps.MMWidth, cProps.MMHeight]);
  Result := ElementFactory.CreateElement(IStripBit, mProps);
  mTitle := SelfProps.PropByName[cProps.Title];
  if mTitle <> nil then
    (Result as INode).AddChild(ElementFactory.CreateElement(ITextBit, NewProps.SetProp(cProps.Text, mTitle)) as INode);
  (Result as INode).AddChild(ElementFactory.CreateElement(IEditBit, NewProps.SetProp(cProps.Text, SelfProps.PropByName[cProps.Value])) as INode);
end;

{ TDesignComponentForm }

function TDesignComponentForm.DoCompose(const AParentElement: IMetaElement
  ): IMetaElement;
var
  mProps: IProps;
begin
  mProps := SelfProps.Clone([cProps.Title, cProps.Layout, cProps.Color,
    cProps.SizeNotifier, cProps.MoveNotifier, cProps.ActivateNotifier]);
  if mProps.PropByName[cProps.Color] = nil then
    mProps.SetProp(AParentElement.Props.PropByName[cProps.Color]);
  { depend on size notifier above - will take info from storage, not from here
  mProps.SetInt(cProps.MMWidth, MMWidth);
  mProps.SetInt(cProps.MMHeight, MMHeight);
  mProps.SetInt(cProps.MMLeft, MMLeft);
  mProps.SetInt(cProps.MMTop, MMTop);
  }
  Result := ElementFactory.CreateElement(IMainFormBit, mProps);
end;

{ TDesignComponentMainForm }

{ TDesignComponent }

function TDesignComponent.NewProps: IProps;
begin
  Result := IProps(Factory.Locate(IProps));
end;

function TDesignComponent.NewNotifier(const AActionID: integer): IFluxNotifier;
begin
  Result := IFluxNotifier(Factory.Locate(IFluxNotifier, '', NewProps.SetInt('ActionID', AActionID)));
end;

function TDesignComponent.Compose(const AParentElement: IMetaElement
  ): IMetaElement;
begin
  Result := DoCompose(AParentElement);
end;

end.
