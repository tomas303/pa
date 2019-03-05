unit tal_uwindowlog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, trl_ilog, Forms, StdCtrls, Controls;

type

  { TWindowLog }

  TWindowLog = class(TInterfacedObject, ILog)
  private
    fLogForm: TCustomForm;
    fLogMemo: TMemo;
    fLevel: string;
    procedure IncLevel;
    procedure DecLevel;
    procedure NewLogForm;
    procedure OnLogFormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure AddLine(const AText: string);
  protected
    // ILog
    procedure DebugLn(const s: string = ''); overload;
    procedure DebugLn(const S: String; Args: array of const); overload;
    procedure DebugLnEnter(const s: string = ''); overload;
    procedure DebugLnEnter(s: string; Args: array of const); overload;
    procedure DebugLnExit(const s: string = ''); overload;
    procedure DebugLnExit(s: string; Args: array of const); overload;
    function GetVisible: Boolean;
    procedure SetVisible(AValue: Boolean);
    property Visible: Boolean read GetVisible write SetVisible;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{ TWindowLog }

procedure TWindowLog.IncLevel;
begin
  fLevel := fLevel + '  ';
end;

procedure TWindowLog.DecLevel;
begin
  fLevel := copy(fLevel, 1, Length(fLevel) - 2);
end;

procedure TWindowLog.NewLogForm;
begin
  fLogForm := TCustomForm.CreateNew(nil);
  fLogForm.Caption := 'LOG';
  fLogForm.FormStyle := fsStayOnTop;
  fLogForm.OnCloseQuery := @OnLogFormCloseQuery;
  fLogMemo := TMemo.Create(fLogForm);
  fLogMemo.Parent := fLogForm;
  fLogMemo.Align := alClient;
  fLogMemo.Font.Name := 'DejaVu Sans Mono';
  fLogMemo.Font.Size := 10;
  fLogMemo.Visible := True;
  fLogForm.Left := Screen.Width - fLogForm.Width;
  fLogForm.Top := Screen.Height - fLogForm.Height;
  fLogForm.WindowState := wsMinimized;
  fLogForm.ShowInTaskBar := stNever;
end;

procedure TWindowLog.OnLogFormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  CanClose := False;
end;

procedure TWindowLog.AddLine(const AText: string);
begin
  fLogMemo.Lines.Add(fLevel + AText);
end;

procedure TWindowLog.DebugLn(const s: string);
begin
  AddLine(s);
end;

procedure TWindowLog.DebugLn(const S: String; Args: array of const);
begin
  DebugLn(Format(S, Args));
end;

procedure TWindowLog.DebugLnEnter(const s: string);
begin
  DebugLn('enter ' + s);
  IncLevel;
end;

procedure TWindowLog.DebugLnEnter(s: string; Args: array of const);
begin
  DebugLnEnter(Format(S, Args));
end;

procedure TWindowLog.DebugLnExit(const s: string);
begin
  DecLevel;
  DebugLn('exit ' + s);
end;

procedure TWindowLog.DebugLnExit(s: string; Args: array of const);
begin
  DebugLnExit(Format(s, Args));
end;

function TWindowLog.GetVisible: Boolean;
begin
  Result := fLogForm.Visible;
end;

procedure TWindowLog.SetVisible(AValue: Boolean);
begin
  fLogForm.Visible := AValue;
end;

procedure TWindowLog.AfterConstruction;
begin
  inherited AfterConstruction;
  NewLogForm;
end;

procedure TWindowLog.BeforeDestruction;
begin
  FreeAndNil(fLogForm);
  inherited BeforeDestruction;
end;

end.

