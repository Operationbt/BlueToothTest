unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Bluetooth, System.Bluetooth.Components, FMX.Layouts, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, BTconfig;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Bluetooth1: TBluetooth;
    lst1: TListBox;
    btn1: TButton;
    Layout_Searching: TLayout;
    lbl1: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    AniIndicator3: TAniIndicator;
    AniIndicator4: TAniIndicator;
    btn2: TButton;
    lst2: TListBox;
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Bluetooth1DiscoveryEnd(const Sender: TObject;
      const ADeviceList: TBluetoothDeviceList);
    procedure FormCreate(Sender: TObject);
    procedure lst1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
    BTMethod : TBTMethod;
    TargetPaireNo : integer;                // ���� ������ �� ����̽� No
  public
    { Public declarations }
    FScanedDevices : TBluetoothDeviceList;
  end;

var
  Form1: TForm1;

implementation


{$R *.fmx}

uses
  Androidapi.JNI.Bluetooth,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText;


procedure TForm1.Bluetooth1DiscoveryEnd(const Sender: TObject;
  const ADeviceList: TBluetoothDeviceList);
var
  i : Integer;
begin
  FScanedDevices := ADeviceList;

  for i := 0 to FScanedDevices.Count - 1 do
  begin
    lst1.Items.Add(FScanedDevices.Items[i].DeviceName);
  end;

  Layout_Searching.Visible := False;

end;

procedure TForm1.btn1Click(Sender: TObject);
var
  Adapter: JBluetoothAdapter;
begin
  //���������� ���������� �ֺ� ��ġ�� �˻��Ѵ�.
  if Bluetooth1.StateConnected = True then
  begin

    Bluetooth1.DiscoverDevices(10000);

    //���⿡ 10�ʵ��� �˻��ϸ鼭 �ٸ�â ����.
    Layout_Searching.Visible := True;
    //�˻��Ǵ� ���� ��� â�� ���ִ� �κ��� DiscoveryEnd�� �־���Ѵ�.
  end
  else
    ShowMessage('���������� �����ֽ��ϴ�.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Layout_Searching.Visible := False;
  Layout_Searching.Align := TAlignLayout.Client;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Adapter: JBluetoothAdapter;
begin
  Bluetooth1.Enabled := True;

  //���������� ���������� �ڵ����� �������� ON
  if Bluetooth1.StateConnected = False then
  begin
    Adapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
    if Adapter.enable then
      //ShowMessage('Bluetooth�� Ȱ��ȭ�մϴ�.')
    else
      ShowMessage('����� �� �����ϴ�.');
  end;

  BTMethod := TBTMethod.Create //BTconfig��ü ����

end;

procedure TForm1.lst1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  i : Integer;
begin
  //�˻��� ��ġ�� ������ �ٷ� ��
  Bluetooth1.Pair(FScanedDevices.Items[Item.Index]);

  //�˻� ����Ʈ���� ���� �̸��� �� ����Ʈ�� �̸��� ���Ͽ� �� ����Ʈ �ε��� ����
  for i := 0 to Bluetooth1.PairedDevices.Count do
  begin
    if Item.Text = Bluetooth1.PairedDevices.Items[i].DeviceName then
      TargetPaireNo := i;
  end;



  //���񽺿� �ø��� �ִ��� �Ǻ�, ������ �����Ҽ� ���� ��ġ��� �ȳ�.






end;

end.