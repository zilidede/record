unit  classtypeBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls;

type
  TRemindRecord = record
    id: Integer;
    remindTitle: string;
    remindLocation: string;
    starTime: string;
    stopTime: string;
    remindContent: string;
  end;

  TMyRemindEvent = procedure(Sender: TObject; myRemind: TRemindRecord) of object;

  TfrmClasstype = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    mmContent: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    edtTitle: TEdit;
    edtLocation: TEdit;
    Button1: TButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    FRemindEvent: TMyRemindEvent;
    property OnremindEvent: TMyRemindEvent read FRemindEvent write FRemindEvent;
  end;

var
  frmClasstype: TfrmClasstype;

implementation

{$R *.dfm}

procedure TfrmClasstype.Button1Click(Sender: TObject);
var
  sqlS: string;
  myRemind: TRemindRecord;
begin
  //����
  myRemind.remindTitle := edtTitle.Text;
  myRemind.remindLocation := edtLocation.Text;
  myRemind.starTime := FormatDateTime('YYYY-MM-DD ', DateTimePicker1.Date) + FormatDateTime('HH', SpinEdit1.Value) +FormatDateTime('MM',SpinEdit2.Value) ;
  myRemind.stopTime := FormatDateTime('YYYY-MM-DD ', DateTimePicker2.Date) + FormatDateTime('HH', SpinEdit3.Value) +FormatDateTime('MM',SpinEdit4.Value) ;
  myRemind.remindContent := mmContent.Text;
  if Assigned(FRemindEvent) then
  begin
    OnremindEvent(Self, myRemind);
  end;
  Self.Close;
end;

procedure TfrmClasstype.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Now;
  DateTimePicker2.Date := Now;
end;

end.

