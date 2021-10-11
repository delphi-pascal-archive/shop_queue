unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids;

const
  lAdjust : Real = 1 / 5;
  lPayment : Real = 1.0;
  lGet : Real = 1 / 2;
  lArrival : Real = 45 / 60;  // �������� ���-�� ���. ����������� ��� �������� �������� (����� ������ 1.33 ���)
  chairNum = 4;
  MaxQueue = 100; // ������������ ���������� ����� � �������
  cashierNum = 3; //���������� ��������

type
  TfrmMain = class(TForm)
    pnlMain: TPanel;
    btnStart: TBitBtn;
    pnlLeft: TPanel;
    pnlBottom: TPanel;
    splBottom: TSplitter;
    pnlRight: TPanel;
    splLeft: TSplitter;
    splRight: TSplitter;
    pnlMiddle: TPanel;
    pnlBottomLeft: TPanel;
    pnlBottomRight: TPanel;
    Splitter1: TSplitter;
    sgChair: TStringGrid;
    sgMoney: TStringGrid;
    sgGet: TStringGrid;
    sgCome: TStringGrid;
    sgLeft: TStringGrid;
    tmArrival: TTimer;
    tmMoney: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblPeople1: TLabel;
    lblPeople2: TLabel;
    lblPeople3: TLabel;
    lblPeople0: TLabel;
    tmUpdate: TTimer;
    lblPeople4: TLabel;
    Label6: TLabel;
    lblAvPeople: TLabel;
    Label7: TLabel;
    lblAvTime: TLabel;
    Label8: TLabel;
    lblAvBuyTime: TLabel;
    Label9: TLabel;
    lblAvClient: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure tmArrivalTimer(Sender: TObject);
    procedure tmMoneyTimer(Sender: TObject);
    procedure tmUpdateTimer(Sender: TObject);

  private
    { Private declarations }
    aTime: Real;       // ����� ����������� (a - Arrival :) ������
    lastaTime: Real;    // ��������� ����� ����������� ������

    chTimers: array [0..chairNum - 1] of TTimer;
    chArrive: array [0..chairNum - 1] of Real;  // ����� �������� �� ����
    chLeft:   array [0..chairNum - 1] of Real;  // �����, �������� ������ �� �����
    chIsFree: array [0..chairNum - 1] of Boolean;  // ���� ��������
    chairsBusy: Integer;
    chQueueTime: array [0..MaxQueue - 1] of Real; //����� ������� ������ � ������� �� ������
    chQueueCount: Integer;  //���������� ����� � ������� ����� �������� :)

    MoneyTime: array [0..MaxQueue - 1] of Real; //����� ������� ������ � ������� � ��������
    MoneyCount: Integer;  //���������� ����� � ������� ����� �������� :)
    MoneyTimeLast: Real;  //�����, ������� ����� ������ ��� ������

    csTimers: array [0..cashierNum - 1] of TTimer;
    csArrive: array [0..cashierNum - 1] of Real;  // ����� �������� � �������
    csLeft:   array [0..cashierNum - 1] of Real;  // �����, �������� ������ � �������
    csIsFree: array [0..cashierNum - 1] of Boolean;  // ������ ��������
    cashiersBusy: Integer;
    csQueueTime: array [0..MaxQueue - 1] of Real; //����� ������� ������ � ������� � ��������
    csQueueCount: Integer;  //���������� ����� � ������� ����� ���������

    people:   array [0..4] of Integer;  // ��� '0' - ����� ����� ����������� ������, ��������� - ����
        // 4 - �� �����. �� ��� ��� ���� �������.
    stayTime: array [1..3] of Real; // ����� ���������� � ����� 1-3

    updateCount: Integer;
    peopleInQueue: array [1..3] of Integer;
    totalClientCount: Integer;

    function TimeSimple(prevTime: Real; lambda: Real) : Real;    // ����� ����������� ������� (������)
    function TheoreticalTimeToReal(theor: Real) : Integer; // �� ��������� � ��.
    function TimeToString(time: Real) : String; // ������� ���. ������� � �:��

    procedure AddStr(time: String; str: String; var sg: TStringGrid); //��������� �-� ��� ���������� ������ � ����� �� �����������

    procedure Arrived(time: Real);  // ��������� �������� ����������

    procedure EnqueueChair(time: Real);  // ������� ��� �� �������� (chair - ���� ������� ��� �� ���� :)
    procedure tmChairTimer(Sender: TObject);
    function IsChairFree : Boolean;

    procedure EnqueueMoney(time:Real); // �������� ������� ������

    procedure EnqueueCashier(time: Real);  // ������� ��� � �������
    procedure tmCashierTimer(Sender: TObject);
    function IsCashierFree : Boolean;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormResize(Sender: TObject);
// ��� ���... ����� ������� ����
begin
  pnlLeft.Width := pnlMain.ClientWidth div 3;
  pnlRight.Width := pnlLeft.Width;
  pnlBottom.Height := pnlMain.ClientHeight div 2;
  pnlBottomLeft.Width := pnlMain.ClientWidth div 2;
end;

function TfrmMain.TimeSimple(prevTime: Real; lambda: Real) : Real;    // ����� ����������� ������� (������)
var u: Real;
begin
//  Result := prevTime + 1 / lambda;
  u := Random;
  Result := prevTime - ln(u) / lambda;
end;

function TfrmMain.TheoreticalTimeToReal(theor: Real) : Integer; // �� ��������� � ��.
begin
  Result := Trunc((theor * 60 * 1000) / 500);  // ���� � ��� �� � 2 ���� ������� ��� �� ����� ����!
  if (Result <= 1) then   // �� ������� �������� ������ ����� ������������
    Result := 1;    // 1 - ����� ����������� ��������, ���������� ��� �������
end;

function TfrmMain.TimeToString(time: Real) : String; // ������� ���. ������� � �:��
begin
  Result := IntToStr(Trunc(time)) + ':' + IntToStr(Trunc((time - Int(time)) * 60))
end;

procedure TfrmMain.AddStr(time: String; str: String; var sg: TStringGrid);
var i: Integer;                     // �������� ����� �������
begin          
  i := sg.RowCount - 1;
  if (sg.Cells[0, i] <> '') then
  begin
    Inc(i);
    sg.RowCount := i + 1;
  end;
  sg.Cells[0, i] := time;
  sg.Cells[1, i] := str;
end;

procedure TfrmMain.Arrived(time: Real);
begin
  Inc(people[0]);

  AddStr(TimeToString(time), '������ ���������� �' + IntToStr(people[0]), sgCome);
  sgCome.Row := sgCome.RowCount - 1;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var i : Integer;
begin
  Randomize;
  sgChair.RowCount := chairNum + 1;
  sgGet.RowCount := cashierNum + 1;
  aTime := 0.0;
  btnStart.Tag := 0;
  for i := 0 to chairNum - 1 do
  begin
    chTimers[i] := TTimer.Create(frmMain);
    chTimers[i].Enabled := False;
    chTimers[i].OnTimer := tmChairTimer;
    chTimers[i].Tag := i;

    chArrive[i] := 0.0;
    chLeft[i] := 0.0;
    chIsFree[i] := True;
  end;
  chairsBusy := 0;

  for i := 0 to cashierNum - 1 do
  begin
    csTimers[i] := TTimer.Create(frmMain);
    csTimers[i].Enabled := False;
    csTimers[i].OnTimer := tmCashierTimer;
    csTimers[i].Tag := i;

    csArrive[i] := 0.0;
    csLeft[i] := 0.0;
    csIsFree[i] := True;
  end;
  cashiersBusy := 0;

  for i := 0 to MaxQueue - 1 do
  begin
    chQueueTime[i] := 0.0;
    MoneyTime[i]   := 0.0;
    csQueueTime[i] := 0.0;
  end;
  chQueueCount := 0;
  MoneyCount := 0;
  csQueueCount := 0;

  for i := 0 to 4 do
    people[i] := 0;

  stayTime[1] := 0.0;
  stayTime[2] := 0.0;
  stayTime[3] := 0.0;

  updateCount := 0;
  peopleInQueue[1] := 0;
  peopleInQueue[2] := 0;
  peopleInQueue[3] := 0;
  totalClientCount := 0; 
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  // �������� �� ����� - ������ �������� �� ����, ����� �������� ��������
  if (btnStart.Tag = 1) then
  begin
    btnStart.Tag := 0;
    btnStart.Caption := '&Start';
    tmArrival.Enabled := False;
//    tmArrival.Enabled := False;
    tmUpdate.Enabled := False;
  end
  else
  begin
    btnStart.Tag := 1;                             // ������������� ��������
    btnStart.Caption := '&Stop';
    tmArrival.Interval := 1;
    tmArrival.Enabled := True;
    tmUpdate.Enabled := True;
  end;
end;

procedure TfrmMain.tmArrivalTimer(Sender: TObject);
begin
  tmArrival.Enabled := False;
  Arrived(aTime);
  lastaTime := aTime;

  EnqueueChair(aTime);

  aTime := TimeSimple(aTime, lArrival);
  tmArrival.Interval := TheoreticalTimeToReal(aTime - lastaTime);
  tmArrival.Enabled := True;
end;

procedure TfrmMain.EnqueueChair(time: Real);  // ������� ��� �� �������� (chair - ���� ������� ��� �� ���� :)
var i: Integer;
begin
  if IsChairFree then
  begin
    for i := 0 to chairNum - 1 do
    begin
      if chIsFree[i] then
      begin
        chIsFree[i] := False;
        Inc(chairsBusy);
        chArrive[i] := time;
        chLeft[i] := TimeSimple(0, lAdjust); // ������� ������� ��� ������
        sgChair.Cells[0, i + 1] := TimeToString(chArrive[i]);
        sgChair.Cells[1, i + 1] := '���� ����� ' + TimeToString(chLeft[i]);
        chTimers[i].Interval := TheoreticalTimeToReal(chLeft[i]);
        chTimers[i].Enabled := True;
        Break;
      end
    end;
  end else
  begin
    if (chQueueCount < MaxQueue) then // ���� ������� �� �����������
    begin
      Inc(chQueueCount);
      chQueueTime[chQueueCount - 1] := time;
      AddStr(TimeToString(time), '������� � �������', sgChair);
    end else
    begin     // ���� �����������, �������� ��� �� ���!
      AddStr(TimeToString(time), '����, ��� � �� ��������', sgLeft); // ���� �� ��������� :)
      sgLeft.Row := sgLeft.RowCount - 1;

      Inc(people[4]);
    end;
  end;
end;

procedure TfrmMain.tmChairTimer(Sender: TObject);
var i, j: Integer;
    time: Real;
begin
  (Sender as TTimer).Enabled := False; // ��-������� ������������� �������� :)
  i := (Sender as TTimer).Tag; // ����� ����� ����� �� ���������� ����������
  time := chArrive[i] + chLeft[i];

  stayTime[1] := stayTime[1] + chLeft[i]; // ����� ���������� �������������
    // ������ ����� ������������� �������.

  chArrive[i] := 0.0;
  chLeft[i] := 0.0;
  chIsFree[i] := True;
  Dec(chairsBusy);
  // ���� ������� �������� �� ������
  sgChair.Cells[0, i + 1] := '';
  sgChair.Cells[1, i + 1] := '';

  inc(people[1]); //����������� ���-�� ����������� ����� �� ������ ����

  // ����� ���� ������� ��� �� 2-� �������
  EnqueueMoney(time);

  // ����� ���� ����� �� ������� ����� �������� � ������ �� �� �����. ����
  if (chQueueCount > 0) then
  begin
  // ���� ������� ���� �� �������, �� ������ ��� � �������� �������. ������.
    EnqueueChair(time); // ������� ������
  // ������ ���� ������� ����� �������� �� ������� (���� �� ����� ���)
    for j := 1 to chQueueCount - 1 do
    begin
      chQueueTime[j - 1] := chQueueTime[j];
      sgChair.Cells[0, j + chairNum] := sgChair.Cells[0, j + chairNum + 1];
      sgChair.Cells[1, j + chairNum] := sgChair.Cells[1, j + chairNum + 1];
    end;
    sgChair.RowCount := sgChair.RowCount - 1;
    Dec(chQueueCount);
  end;
end;

function TfrmMain.IsChairFree() : Boolean;
begin
  Result := (chairsBusy < chairNum);
end;

procedure TfrmMain.EnqueueMoney(time:Real); // �������� ������� ������
begin
  if (MoneyCount >= MaxQueue) then // ���� ������� (2-�) �����������! (����� ���� ��������)
  begin
    AddStr(TimeToString(time), '����, ��� � �� ��������', sgLeft); // ���� �� ���������� :)
    sgLeft.Row := sgLeft.RowCount - 1;
    Inc(people[4]);
    exit;
  end;

  AddStr(TimeToString(time), '������� � �������', sgMoney);
  if (MoneyCount = 0) then // ���� ������� ������ � �������, �� ���������� ��� ��������������
  begin
    MoneyTimeLast := TimeSimple(0, lPayment);
    sgMoney.Cells[1, 1] := sgMoney.Cells[1, 1] + ' ('
                         + TimeToString(MoneyTimeLast) + ')';
    tmMoney.Interval := TheoreticalTimeToReal(MoneyTimeLast);
    tmMoney.Enabled := True;

    MoneyTime[0] := time;
    Inc(MoneyCount);
  end
  else
  begin
    Inc(MoneyCount);
    MoneyTime[MoneyCount - 1] := time;
  end;
end;

procedure TfrmMain.tmMoneyTimer(Sender: TObject);
var i: Integer;
    time: Real;
begin
  tmMoney.Enabled := False;
  time := MoneyTime[0] + MoneyTimeLast;

  stayTime[2] := stayTime[2] + MoneyTimeLast; // ����� ���������� �������������
    // ������ ����� ������������� �������.

  // ���� ������� �������� �� ������
  sgMoney.Cells[0, 1] := '';
  sgMoney.Cells[1, 1] := '';

  inc(people[2]); //����������� ���-�� ����������� ����� �� ������ ����

  // ������ ������� ��������� ����� �������� � ������ �������
  EnqueueCashier(time);

  if (MoneyCount > 1) then
  begin
    for i := 1 to MoneyCount - 1 do
    begin
      MoneyTime[i - 1] := MoneyTime[i];
      sgMoney.Cells[0, i] := sgMoney.Cells[0, i + 1];
      sgMoney.Cells[1, i] := sgMoney.Cells[1, i + 1];
    end;
    MoneyTime[0] := time;
    sgMoney.RowCount := sgMoney.RowCount - 1;
    MoneyTimeLast := TimeSimple(0, lPayment);
    sgMoney.Cells[0, 1] := TimeToString(time);
    sgMoney.Cells[1, 1] := sgMoney.Cells[1, 1] + ' ('
                         + TimeToString(MoneyTimeLast) + ')';
    tmMoney.Interval := TheoreticalTimeToReal(MoneyTimeLast);
    tmMoney.Enabled := True;
  end;
  Dec(MoneyCount);
end;

procedure TfrmMain.tmCashierTimer(Sender: TObject);
var i, j: Integer;
    time: Real;
begin
  (Sender as TTimer).Enabled := False; // ��-������� ������������� ������ :)
  i := (Sender as TTimer).Tag; // ����� ����� ������� �� ���������� ����������
  time := csArrive[i] + csLeft[i];

  stayTime[3] := stayTime[3] + csLeft[i]; // ����� ���������� �������������
    // ������ ����� ������������� �������.

  csArrive[i] := 0.0;
  csLeft[i] := 0.0;
  csIsFree[i] := True;
  Dec(cashiersBusy);
  // ���� ������� �������� �� ������
  sgGet.Cells[0, i + 1] := '';
  sgGet.Cells[1, i + 1] := '';

  inc(people[3]); //����������� ���-�� ����������� ����� �� ������� ����

  // ����� ���� ��������� ��� � �������� "�����!"
  AddStr(TimeToString(time), '�����', sgLeft);
  sgLeft.Row := sgLeft.RowCount - 1;
  
  // ����� ���� ����� �� ������� ����� ��������� � ���������� �������
  if (csQueueCount > 0) then
  begin
  // ���� ������� ���� �� �������, �� ������ ��� � �������� �������. ������.
    EnqueueCashier(time); // ������� ������
  // ������ ���� ������� ����� �������� �� ������� (���� �� ����� ���)
    for j := 1 to csQueueCount - 1 do
    begin
      csQueueTime[j - 1] := csQueueTime[j];
      sgGet.Cells[0, j + cashierNum] := sgGet.Cells[0, j + cashierNum + 1];
      sgGet.Cells[1, j + cashierNum] := sgGet.Cells[1, j + cashierNum + 1];
    end;
    sgGet.RowCount := sgGet.RowCount - 1;
    Dec(csQueueCount);
  end;
end;

procedure TfrmMain.EnqueueCashier(time: Real);  // ������� ��� � �������
var i: Integer;
begin
  if IsCashierFree then
  begin
    for i := 0 to cashierNum - 1 do
    begin
      if csIsFree[i] then
      begin
        csIsFree[i] := False;
        Inc(cashiersBusy);
        csArrive[i] := time;
        csLeft[i] := TimeSimple(0, lGet); // ������� ������� ��� ������ :)
        sgGet.Cells[0, i + 1] := TimeToString(csArrive[i]);
        sgGet.Cells[1, i + 1] := '���� ����� ' + TimeToString(csLeft[i]);
        csTimers[i].Interval := TheoreticalTimeToReal(csLeft[i]);
        csTimers[i].Enabled := True;
        Break;
      end
    end;
  end else
  begin
    if (csQueueCount < MaxQueue) then // ���� ������� �� �����������
    begin
      Inc(csQueueCount);
      csQueueTime[csQueueCount - 1] := time;
      AddStr(TimeToString(time), '������� � �������', sgGet);
    end else
    begin     // ���� �����������, �������� ��� �����!
      AddStr(TimeToString(time), '����, ��� � �� �������', sgLeft); // ���� �� ��������� :)
      sgLeft.Row := sgLeft.RowCount - 1;

      Inc(people[4]);
    end;
  end;
end;

function TfrmMain.IsCashierFree() : Boolean;
begin
  Result := (cashiersBusy < cashierNum);
end;   

procedure TfrmMain.tmUpdateTimer(Sender: TObject);
begin
  Inc(updateCount);
  Inc(peopleInQueue[1], chQueueCount);
  Inc(peopleInQueue[2], MoneyCount);
  Inc(peopleInQueue[3], csQueueCount);
  Inc(totalClientcount, people[3]);

  lblPeople0.Caption := IntToStr(people[0]);
  lblPeople1.Caption := IntToStr(people[1]) + ' / ' + IntToStr(chQueueCount);
  lblPeople2.Caption := IntToStr(people[2]) + ' / ' + IntToStr(MoneyCount);
  lblPeople3.Caption := IntToStr(people[3]) + ' / ' + IntToStr(csQueueCount);
  lblPeople4.Caption := IntToStr(people[4]);
//  if (people[0] <> 0) then
//    lblAvPeople.Caption := FloatToStrF(people[1] / people[0], ffFixed, 10, 3)
//          + ' / ' + FloatToStrF(people[2] / people[0], ffFixed, 10, 3)
//          + ' / ' + FloatToStrF(people[3] / people[0], ffFixed, 10, 3);
  if (updateCount <> 0) then
    lblAvPeople.Caption := FloatToStrF(peopleInQueue[1] / updateCount, ffFixed, 10, 3)
          + ' / ' + FloatToStrF(peopleInQueue[2] / updateCount, ffFixed, 10, 3)
          + ' / ' + FloatToStrF(peopleInQueue[3] / updateCount, ffFixed, 10, 3);
  if (aTime <> 0) then
  begin
    lblAvTime.Caption := FloatToStrF(stayTime[1] / aTime, ffFixed, 10, 3)
          + ' / ' + FloatToStrF(stayTime[2] / aTime, ffFixed, 10, 3)
          + ' / ' + FloatToStrF(stayTime[3] / aTime, ffFixed, 10, 3);
    lblAvClient.Caption := FloatToStrF(people[3] / aTime, ffFixed, 10, 3);
  end;

  if (people[3] <> 0) then
    lblAvBuyTime.Caption := FloatToStrF((stayTime[1] + stayTime[2] + stayTime[2]) / people[3], ffFixed, 10, 3)

end;

end.                                                
