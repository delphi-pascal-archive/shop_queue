unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Grids;

const
  lAdjust : Real = 1 / 5;
  lPayment : Real = 1.0;
  lGet : Real = 1 / 2;
  lArrival : Real = 45 / 60;  // пересчёт кол-во мин. необходимых для прибытия человека (через каждые 1.33 мин)
  chairNum = 4;
  MaxQueue = 100; // максимальное количество людей в очереди
  cashierNum = 3; //количество кассиров

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
    aTime: Real;       // время поступления (a - Arrival :) заявки
    lastaTime: Real;    // последнее время поступления заявки

    chTimers: array [0..chairNum - 1] of TTimer;
    chArrive: array [0..chairNum - 1] of Real;  // время прибытия на стул
    chLeft:   array [0..chairNum - 1] of Real;  // время, осталось сидеть на стуле
    chIsFree: array [0..chairNum - 1] of Boolean;  // стул свободен
    chairsBusy: Integer;
    chQueueTime: array [0..MaxQueue - 1] of Real; //когда человек пришёл в очередь со стулом
    chQueueCount: Integer;  //количество людей в очереди перед стульями :)

    MoneyTime: array [0..MaxQueue - 1] of Real; //когда человек пришёл в очередь с деньгами
    MoneyCount: Integer;  //количество людей в очереди перед стульями :)
    MoneyTimeLast: Real;  //время, сколько будет длится его оплата

    csTimers: array [0..cashierNum - 1] of TTimer;
    csArrive: array [0..cashierNum - 1] of Real;  // время прибытия к кассиру
    csLeft:   array [0..cashierNum - 1] of Real;  // время, осталось стоять у кассира
    csIsFree: array [0..cashierNum - 1] of Boolean;  // кассир свободен
    cashiersBusy: Integer;
    csQueueTime: array [0..MaxQueue - 1] of Real; //когда человек пришёл в очередь с кассиром
    csQueueCount: Integer;  //количество людей в очереди перед кассирами

    people:   array [0..4] of Integer;  // при '0' - общее число поступления заявки, остальное - фазы
        // 4 - не обраб. по той или иной причине.
    stayTime: array [1..3] of Real; // время пребывания в фазах 1-3

    updateCount: Integer;
    peopleInQueue: array [1..3] of Integer;
    totalClientCount: Integer;

    function TimeSimple(prevTime: Real; lambda: Real) : Real;    // Время наступления события (любого)
    function TheoreticalTimeToReal(theor: Real) : Integer; // всё считается в мс.
    function TimeToString(time: Real) : String; // Перевод нат. времени в с:мс

    procedure AddStr(time: String; str: String; var sg: TStringGrid); //служебная ф-я для добавления строки в любой из компонентов

    procedure Arrived(time: Real);  // Процедура прибытия покупателя

    procedure EnqueueChair(time: Real);  // добавим его на примерку (chair - типа посадим его на стул :)
    procedure tmChairTimer(Sender: TObject);
    function IsChairFree : Boolean;

    procedure EnqueueMoney(time:Real); // отправим платить деньги

    procedure EnqueueCashier(time: Real);  // добавим его к кассиру
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
// Это так... чтобы красиво было
begin
  pnlLeft.Width := pnlMain.ClientWidth div 3;
  pnlRight.Width := pnlLeft.Width;
  pnlBottom.Height := pnlMain.ClientHeight div 2;
  pnlBottomLeft.Width := pnlMain.ClientWidth div 2;
end;

function TfrmMain.TimeSimple(prevTime: Real; lambda: Real) : Real;    // Время наступления события (любого)
var u: Real;
begin
//  Result := prevTime + 1 / lambda;
  u := Random;
  Result := prevTime - ln(u) / lambda;
end;

function TfrmMain.TheoreticalTimeToReal(theor: Real) : Integer; // всё считается в мс.
begin
  Result := Trunc((theor * 60 * 1000) / 500);  // типа у нас всё в 2 раза быстрее чем на самом деле!
  if (Result <= 1) then   // от быстрой скорости таймер может остановиться
    Result := 1;    // 1 - самое минимальное значение, разрешимой для таймера
end;

function TfrmMain.TimeToString(time: Real) : String; // Перевод нат. времени в с:мс
begin
  Result := IntToStr(Trunc(time)) + ':' + IntToStr(Trunc((time - Int(time)) * 60))
end;

procedure TfrmMain.AddStr(time: String; str: String; var sg: TStringGrid);
var i: Integer;                     // создание формы таблицы
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

  AddStr(TimeToString(time), 'Пришёл покупатель №' + IntToStr(people[0]), sgCome);
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
  // нажимаем на Старт - кнопка меняется на Стоп, прога начинает работать
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
    btnStart.Tag := 1;                             // Соответсвенно наоборот
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

procedure TfrmMain.EnqueueChair(time: Real);  // добавим его на примерку (chair - типа посадим его на стул :)
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
        chLeft[i] := TimeSimple(0, lAdjust); // сколько времени ему сидеть
        sgChair.Cells[0, i + 1] := TimeToString(chArrive[i]);
        sgChair.Cells[1, i + 1] := 'Уйдёт через ' + TimeToString(chLeft[i]);
        chTimers[i].Interval := TheoreticalTimeToReal(chLeft[i]);
        chTimers[i].Enabled := True;
        Break;
      end
    end;
  end else
  begin
    if (chQueueCount < MaxQueue) then // если очередь не переполнена
    begin
      Inc(chQueueCount);
      chQueueTime[chQueueCount - 1] := time;
      AddStr(TimeToString(time), 'Ожидает в очереди', sgChair);
    end else
    begin     // если переполнена, выгоняем его на фиг!
      AddStr(TimeToString(time), 'Ушёл, так и не примерив', sgLeft); // ушёл не посидевши :)
      sgLeft.Row := sgLeft.RowCount - 1;

      Inc(people[4]);
    end;
  end;
end;

procedure TfrmMain.tmChairTimer(Sender: TObject);
var i, j: Integer;
    time: Real;
begin
  (Sender as TTimer).Enabled := False; // по-резкому останавливаем примерку :)
  i := (Sender as TTimer).Tag; // узнаём номер стула из внутренней переменной
  time := chArrive[i] + chLeft[i];

  stayTime[1] := stayTime[1] + chLeft[i]; // время пребывания увеличивается
    // только после возникновения события.

  chArrive[i] := 0.0;
  chLeft[i] := 0.0;
  chIsFree[i] := True;
  Dec(chairsBusy);
  // надо стереть человека из списка
  sgChair.Cells[0, i + 1] := '';
  sgChair.Cells[1, i + 1] := '';

  inc(people[1]); //увеличиваем кол-во обработаных людей на первой фазе

  // далее надо загнать его во 2-ю очередь
  EnqueueMoney(time);

  // Потом берём людей из очереди перед стульями и сажаем их на освоб. стул
  if (chQueueCount > 0) then
  begin
  // берём первого чела из очереди, но сажаем его с временем освобод. чувака.
    EnqueueChair(time); // сначала сажаем
  // теперь надо удалить этого человека из очереди (ведь он сидит уже)
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

procedure TfrmMain.EnqueueMoney(time:Real); // отправим платить деньги
begin
  if (MoneyCount >= MaxQueue) then // если очередь (2-я) переполнена! (такое тоже возможно)
  begin
    AddStr(TimeToString(time), 'Ушёл, так и не заплатив', sgLeft); // ушёл не заплативши :)
    sgLeft.Row := sgLeft.RowCount - 1;
    Inc(people[4]);
    exit;
  end;

  AddStr(TimeToString(time), 'Ожидает в очереди', sgMoney);
  if (MoneyCount = 0) then // если человек первый в очереди, то заставляем его обрабатываться
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

  stayTime[2] := stayTime[2] + MoneyTimeLast; // время пребывания увеличивается
    // только после возникновения события.

  // надо стереть человека из списка
  sgMoney.Cells[0, 1] := '';
  sgMoney.Cells[1, 1] := '';

  inc(people[2]); //увеличиваем кол-во обработаных людей на второй фазе

  // Теперь остаётся отправить этого человека в третью очередь
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
  (Sender as TTimer).Enabled := False; // по-резкому останавливаем оплату :)
  i := (Sender as TTimer).Tag; // узнаём номер кассира из внутренней переменной
  time := csArrive[i] + csLeft[i];

  stayTime[3] := stayTime[3] + csLeft[i]; // время пребывания увеличивается
    // только после возникновения события.

  csArrive[i] := 0.0;
  csLeft[i] := 0.0;
  csIsFree[i] := True;
  Dec(cashiersBusy);
  // надо стереть человека из списка
  sgGet.Cells[0, i + 1] := '';
  sgGet.Cells[1, i + 1] := '';

  inc(people[3]); //увеличиваем кол-во обработаных людей на третьей фазе

  // далее надо отправить его с надписью "КУПИЛ!"
  AddStr(TimeToString(time), 'Купил', sgLeft);
  sgLeft.Row := sgLeft.RowCount - 1;
  
  // Потом берём людей из очереди перед кассирами и заставляем платить
  if (csQueueCount > 0) then
  begin
  // берём первого чела из очереди, но ставим его с временем освобод. чувака.
    EnqueueCashier(time); // сначала ставим
  // теперь надо удалить этого человека из очереди (ведь он стоит уже)
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

procedure TfrmMain.EnqueueCashier(time: Real);  // добавим его к кассиру
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
        csLeft[i] := TimeSimple(0, lGet); // сколько времени ему стоять :)
        sgGet.Cells[0, i + 1] := TimeToString(csArrive[i]);
        sgGet.Cells[1, i + 1] := 'Уйдёт через ' + TimeToString(csLeft[i]);
        csTimers[i].Interval := TheoreticalTimeToReal(csLeft[i]);
        csTimers[i].Enabled := True;
        Break;
      end
    end;
  end else
  begin
    if (csQueueCount < MaxQueue) then // если очередь не переполнена
    begin
      Inc(csQueueCount);
      csQueueTime[csQueueCount - 1] := time;
      AddStr(TimeToString(time), 'Ожидает в очереди', sgGet);
    end else
    begin     // если переполнена, выгоняем его нафиг!
      AddStr(TimeToString(time), 'Ушёл, так и не получив', sgLeft); // ушёл не получивши :)
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
