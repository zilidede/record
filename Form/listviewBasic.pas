unit listviewBasic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmLvsbic = class(TForm)
    edt1: TEdit;
    lv1: TListView;
    procedure edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt1Change(Sender: TObject);
    procedure lv1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FListViewWndProc1: TWndMethod;
    procedure ListViewWndProc1(var Msg: TMessage);
  public
    { Public declarations }
  end;

const
  MaxColumns = 7;  //   ��Columns-1

var
  frmLvsbic: TfrmLvsbic;
  edtcol: integer; //��¼EDIT1��Columns�е�λ��,1-  MaxColumns;
  editem: Tlistitem;

implementation

{$R *.dfm}
procedure TfrmLvsbic.ListViewWndProc1(var Msg: TMessage);
var
  IsNeg: Boolean;
begin
  try
    ShowScrollBar(lv1.Handle, SB_HORZ, false);

        //�϶�Listview1������ʱ,��EDIT1��������
    if (Msg.Msg = WM_VSCROLL) or (Msg.Msg = WM_MOUSEWHEEL) then
      edt1.Visible := false;
    if Msg.Msg = WM_MOUSEWHEEL then
    begin
      if lv1.Selected = nil then
        exit;
      IsNeg := Short(Msg.WParamHi) < 0;
      lv1.SetFocus;
      if IsNeg then
        SendMessage(edt1.Handle, WM_KEYDOWN, VK_down, 0)
      else
        SendMessage(edt1.Handle, WM_KEYDOWN, VK_up, 0);
    end
    else
      FListViewWndProc1(Msg);
  except
  end;
end;

procedure TfrmLvsbic.edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  item: tlistitem;
  ix, lt, i: integer;
  rect: Trect;
begin
  try
  //----���ϡ��¡����ҷ�������д���-----------------
    if (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_RIGHT) and (Key <> VK_LEFT) then
      EXIT;
    if (Key = VK_RIGHT) then  //�����Ҽ�
    begin
     //���¼����Ҽ���,�жϹ��λ���Ƿ������ұ�,����������ұ�,�������� EXIT
      if length(edt1.Text) > edt1.SelStart then
        exit;
      item := lv1.Selected;
     //����edit1λ���ĸ�Columns,���<���Columns,+1,����=1,��ת�������

      if (edtcol < MaxColumns) then
        edtcol := edtcol + 1
      else
        edtcol := 0;
      lt := 0;

    //�� edtcolֵ����� Columns��λ��(Left,width),EDIT1��������

      for i := 0 to edtcol - 1 do
        lt := lt + lv1.Columns[i].Width;
      edt1.Left := lt + 1;
      edt1.Width := lv1.Columns[edtcol].Width;
    end;
    if (Key = VK_left) then  //�������
    begin
      if edt1.SelStart <> 0 then
        exit;
      item := lv1.Selected;
      if (edtcol > 0) then
        edtcol := edtcol - 1
      else
        edtcol := MaxColumns;
      lt := 0;
      for i := 0 to edtcol - 1 do
        lt := lt + lv1.Columns[i].Width;
      edt1.Left := lt + 1;
      edt1.Width := lv1.Columns[edtcol].Width;
    end;
    if (Key = VK_DOWN) then     //�����¼�
    begin
      item := lv1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix >= lv1.Items.Count - 1 then
        exit;
      SendMessage(lv1.Handle, WM_KEYDOWN, VK_down, 0)
    end;
    if (Key = VK_UP) then  //�����ϼ�
    begin
      item := lv1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix < 1 then
        exit;
      SendMessage(lv1.Handle, WM_KEYDOWN, VK_up, 0)
    end;
    lv1.ItemFocused := lv1.Selected;
    item := lv1.Selected;
    edt1.Visible := false;
    rect := item.DisplayRect(drSelectBounds);
    edt1.SetBounds(edt1.left, rect.Top - 1, edt1.Width, rect.Bottom - rect.Top + 2);
    if edtcol > 0 then
      edt1.Text := item.SubItems[edtcol - 1]
    else
      edt1.Text := item.Caption;
    edt1.Visible := true;
    edt1.SetFocus;

  except
  end;
end;





//�༭�ؼ����ݸı��,����ı䵽Listview1��Ӧλ��

procedure TfrmLvsbic.edt1Change(Sender: TObject);
begin
  try
    if not edt1.Visible then
      exit;

    if edtcol = 0 then
      lv1.Selected.Caption := edt1.Text
    else
      lv1.Selected.SubItems[edtcol - 1] := edt1.Text;
  except
  end;
end;

//��LISTVIEW1�ϰ������

procedure TfrmLvsbic.lv1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rect: Trect;
  p: tpoint;
  wtmp, i: integer;
begin
  try
  //��ʾ�༭�ؼ�
    edt1.Visible := false;
  //�������λ�ã��õ�����Ӧ�е�LISTITEM
    editem := lv1.GetItemAt(X, Y);
    if editem <> nil then
    begin
   //�������λ�ã���������ĸ� Columns.
      p := editem.Position;
      wtmp := p.X;
      for i := 0 to lv1.Columns.Count - 1 do
        if (X > wtmp) and (X < (wtmp + lv1.Column[i].Width)) then
          break  //�ҵ���Ӧ��Columns,����˳���Iȷ��.
        else
          inc(wtmp, lv1.Column[i].Width);
   //����I��ֵ��ȡ�� Columns�Ķ�Ӧλ�á��ڶ�Ӧλ�ð�������SIZE��EDIT1��
      edtcol := i;
      rect := editem.DisplayRect(drSelectBounds);
      edt1.SetBounds(wtmp - 1, rect.Top - 1, lv1.Column[i].Width + 1, rect.Bottom - rect.Top + 2);
      if edtcol > 0 then
        edt1.Text := editem.SubItems[i - 1]
      else
        edt1.Text := editem.Caption;
      edt1.Visible := true;
      edt1.SetFocus;
    end;
  except
  end;
end;

//��ʼ��,�����������.
procedure TfrmLvsbic.FormCreate(Sender: TObject);
var
  item: tlistitem;
  i: integer;
begin

 //��edit1�ĸ���ѡΪLISTVIEW1,������ӦLISTVIEW1��Ϣ
  edt1.parent := lv1;
 //����LISTVIEW1�����Ϣ
  FListViewWndProc1 := Lv1.WindowProc;
  Lv1.WindowProc := ListViewWndProc1;
end;



//  ����Ĵ���ֻ��������Ĵ��룬������ͨ�����̵��ϡ��¡����Ҽ�����EDIT�ڸ���Column���л���Ҫ�������ø��ã���Ҫ����������Column�Ŀ��ȱ仯��Ϣ���Ա�Column������խ����Ӧ�ĵ���EDIT���ȵȵȡ�

end.
