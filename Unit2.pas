unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Neural,Rest.Json,System.Json,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Spin, Vcl.StdCtrls,
  Vcl.Grids;

type
  TForm2 = class(TForm)
    StringGridTrain: TStringGrid;
    EditFile: TEdit;
    OpenDialog1: TOpenDialog;
    ButtonOpen: TButton;
    ButtonOpenFile: TButton;
    ButtonTrain: TButton;
    ButtonCal: TButton;
    StringGridAnswer: TStringGrid;
    EditRate: TEdit;
    SpinEditEpoch: TSpinEdit;
    StringGrid3: TStringGrid;
    SpinEditAnswer: TSpinEdit;
    ButtonInit: TButton;
    Edit2: TEdit;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    ButtonReload: TButton;
    EditLSTM: TEdit;
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonInitClick(Sender: TObject);
    procedure ButtonTrainClick(Sender: TObject);
    procedure ButtonCalClick(Sender: TObject);
    procedure ButtonOpenFileClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonReloadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AI:Network;
    AnswerMax:Integer;
    Input,Answer:Array2D;
  end;

  function Convert(Answer:Array of Integer):Array2D;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function Convert(Answer:Array of Integer):Array2D;
var i:Integer;
begin
  SetLength(Result,0,0);
  SetLength(Result,Length(Answer),Form2.AnswerMax);
  for i := 1 to Length(Answer) do
    Result[i-1][Answer[i-1]]:=1;
end;

procedure TForm2.ButtonOpenClick(Sender: TObject);
var i,j,k:Integer;
  csvData:TStringList;
  csvRow:TStringList;
begin
  csvData:=TStringList.Create;
  csvData.StrictDelimiter:=True;
  csvRow:=TStringList.Create;
  csvRow.Delimiter:=',';
  csvData.LoadFromFile(EditFile.Text);
  csvRow.DelimitedText:=csvData[0];
  k:=0;
  for i := 0 to csvRow.Count-1 do
    if csvRow[i]='' then begin k:=i;break;end;
  StringGridTrain.RowCount:=csvData.Count;
  if k=0 then
  begin
    StringGridTrain.ColCount:=csvRow.Count+1;
  end
  else
  begin
    StringGridTrain.ColCount:=csvRow.Count;
  end;
  for i:=0 to csvData.count-1 do
  begin
    csvRow.DelimitedText:=csvData[i];
    for j :=0  to csvRow.Count-1 do
    begin
      StringGridTrain.Cells[j,i]:=csvRow[j];
    end;
    if k=0 then
    begin
      StringGridTrain.Cells[csvRow.Count-1,i]:='';
      StringGridTrain.Cells[csvRow.Count,i]:=csvRow[csvRow.Count-1];
    end;
  end;
  StringGridAnswer.ColCount:=StringGridTrain.ColCount+2;
  if FileExists('test'+EditFile.Text) then
  begin
   csvData.LoadFromFile('test'+EditFile.Text);
   SpinEditAnswer.Value:=csvData.Count;
   StringGridAnswer.RowCount:=SpinEditAnswer.Value;
    for i :=0 to csvData.count-1 do
    begin
      csvRow.DelimitedText:=csvData[i];
      for j:=0 to csvRow.Count-1 do
        StringGridAnswer.Cells[j,i]:=csvRow[j];
      if k=0 then
      begin
        StringGridAnswer.Cells[csvRow.Count-1,i]:='';
        StringGridAnswer.Cells[csvRow.Count,i]:=csvRow[csvRow.Count-1];
      end;
    end;
  end;
  ButtonReload.Click;
end;

procedure TForm2.ButtonOpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  begin
    EditFile.Text:=OpenDialog1.FileName;
    ButtonOpen.Click;
  end;
end;

procedure TForm2.ButtonReloadClick(Sender: TObject);
var i,j,k:Integer;
  StartTime:TDateTime;
begin
  if AI=nil then ButtonInit.Click;
  k:=0;
  StartTIme:=Now;
  for i := 0 to StringGridTrain.ColCount-1 do
    if StringGridTrain.Cells[i,0]='' then begin k:=i;break;end;
  SetLength(Input,StringGridTrain.RowCount,k);
  SetLength(Answer,0,0);
//  SetLength(Answer,StringGrid1.RowCount,AnswerMax);
  if EditFile.Text='trainhand.csv' then
    SetLength(Answer,StringGridTrain.RowCount,10)
  else
    SetLength(Answer,StringGridTrain.RowCount,StringGridTrain.ColCount-k-1);
  for i := 1 to StringGridTrain.RowCount-1 do
    for j := 0 to StringGridTrain.ColCount-1 do
    begin
      if j<k then
      begin
//        if EditFile.Text='trainhand.csv' then
//          Input[i-1][j]:=StrToFloat(StringGridTrain.Cells[j,i-1])
//        else
          Input[i-1][j]:=StrToFloat(StringGridTrain.Cells[j,i-1])/StrToFloat(StringGridTrain.Cells[j,0])
      end
//      else if j>k then Answer[i][Round(StrToFloat(StringGrid1.Cells[j,i]))]:=1;
      else if j>k then
      begin
        if EditFile.Text='trainhand.csv' then
          Answer[i-1][StrToInt(StringGridTrain.Cells[j,i-1])]:=1
        else
          Answer[i-1][j-k-1]:=StrToFloat(StringGridTrain.Cells[j,i-1])/StrToFloat(StringGridTrain.Cells[j,0]);
      end;
    end;
  Label1.Caption:='载入时间：'+FloatToStr((Now-StartTIme)*24*60*60)+'秒';

end;

procedure TForm2.ButtonSaveClick(Sender: TObject);
var f:File of Network;
begin
  Memo1.Lines.Add(TJson.ObjectToJsonString(AI));
  Memo1.Lines.SaveToFile('AI'+FormatDateTime('yyyymmddhhnnss',Now)+'.VAR');
  Memo1.Lines.Clear;

//  AssignFile(f,'AI.VAR');
//  Reset(f);
//  Write(f,AI);
//  CloseFile(f);
  //  WriteComponentResFile('AI.RES',AI.);
end;

procedure TForm2.ButtonTrainClick(Sender: TObject);
var
  Normal:Array1D;
  StartTime:TDateTime;
begin


//  for i := 1 to StringGridTrain.RowCount-1 do
//    for j := 0 to StringGridTrain.ColCount-1 do
//    begin
//      if StringGridTrain.Cells[j,0]='' then
//      begin
//        k:=j;
//        continue;
//      end;
////      if i=0 then Normal[j]:=0;
//      Normal[j]:=Normal[j]+StrToFloat(StringGridTrain.Cells[j,i]);
//    end;
//  for i :=0  to StringGridTrain.ColCount-1 do
//    if i=k then StringGridTrain.Cells[i,0]:=''
//    else StringGridTrain.Cells[i,0]:=FloatToStr(Normal[i]);

  StartTime:=Now;
//  for i := 1 to SpinEditEpoch.Value do
  begin
//    Memo1.Lines.Add('第'+i.ToString+'次训练：');
    AI.train(Input,Answer,SpinEditEpoch.Value,StrToFloat(EditRate.Text));
    Memo1.Lines.Add('学习耗时：'+FloatToStr((Now-StartTIme)*24*60*60)+'秒');
    Memo1.Lines.Add('误差：'+FloatToStr(AI.error));
//    ButtonSave.Click;
    Application.ProcessMessages;
  end;
  Label1.Caption:='学习时间：'+FloatToStr((Now-StartTIme)*24*60*60)+'秒';
  Label2.Caption:='误差：'+FloatToStr(AI.error);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
//  ShowMessage(FloatToStr(ln(Double.MaxValue)));
end;

procedure TForm2.ButtonLoadClick(Sender: TObject);
var f:File of Network;
  AIJson:TJsonObject;
  l:Array of Integer;
  i,j,k:Integer;
begin
  Memo1.Lines.LoadFromFile('AI.VAR');
  AIJson:=TJSONObject(TJsonObject.ParseJSONValue(Memo1.Lines.Text));
  if AI<>nil then AI.Free;
  SetLength(l,AIJson.GetValue<Integer>('layers_size')+1);
  l[0]:=AIJson.GetValue<TJsonArray>('layers').Items[0].GetValue<Integer>('input_size');
  for i :=1 to AIJson.GetValue<Integer>('layers_size') do
    l[i]:=AIJson.GetValue<TJsonArray>('layers').Items[i-1].GetValue<Integer>('output_size');
  AI:=Network.Creat(l,1);
  for i := 0 to AIJson.GetValue<Integer>('layers_size')-1 do
    for j := 0 to AIJson.GetValue<TJsonArray>('layers').Items[i].GetValue<Integer>('output_size')-1 do
    begin
      for k := 0 to AIJson.GetValue<TJsonArray>('layers').Items[i].GetValue<Integer>('input_size')-1 do
      begin
        AI.Layers[i].weights[k,j]:=StrToFloat(TJsonArray(AIJson.GetValue<TJsonArray>('layers').Items[i].GetValue<TJsonArray>('weights').Items[k]).Items[j].ToString);
      end;
      AI.Layers[i].activatorfun:=AIJson.GetValue<TJsonArray>('layers').Items[i].GetValue<Integer>('activatorfun');
      AI.Layers[i].bias[j]:=StrToFloat(AIJson.GetValue<TJsonArray>('layers').Items[i].GetValue<TJsonArray>('bias').Items[j].ToString);
    end;

//  AssignFile(f,'AI.VAR');
//  Reset(f);
//  Read(f,AI);
//  CloseFile(f);
//  ReadComponentResFile('AI.RES',AI);
end;

procedure TForm2.ButtonCalClick(Sender: TObject);
var
  Simple,Answer:Array1D;
  i,j,k:Integer;
  AnswerM:Integer;
  Error:Real;
begin
  k:=0;
  Error:=0;
  for i := 0 to StringGridTrain.ColCount-1 do
    if StringGridTrain.Cells[i,0]='' then begin k:=i;break;end;
  SetLength(Simple,k);
  SetLength(Answer,0);
  if EditFile.Text='trainhand.csv' then
    SetLength(Answer,10)
  else
    SetLength(Answer,StringGridTrain.ColCount-k-1);
  for i := 0 to StringGridAnswer.RowCount-1 do
  begin
    for j := 0 to k-1 do
//      if EditFile.Text='trainhand.csv' then
//        Simple[j]:=StrToFloat(StringGridAnswer.Cells[j,i])
//      else
        Simple[j]:=StrToFloat(StringGridAnswer.Cells[j,i])/StrToFloat(StringGridTrain.Cells[j,0]);
    Answer:=AI.predict(Simple);
    if EditFile.Text='trainhand.csv' then
    begin
      AnswerM:=0;
      for j:=0 to 9 do
        if Answer[AnswerM]<Answer[j] then AnswerM:=j;
      StringGridAnswer.Cells[k+2,i]:=IntToStr(AnswerM);
      StringGridAnswer.Cells[StringGridAnswer.ColCount-1,i]:=FloatToStr(StringGridAnswer.Cells[StringGridAnswer.ColCount-2,i].ToDouble-StringGridAnswer.Cells[StringGridAnswer.ColCount-3,i].ToDouble);
      if StringGridAnswer.Cells[StringGridAnswer.ColCount-2,i].ToDouble-StringGridAnswer.Cells[StringGridAnswer.ColCount-3,i].ToDouble<>0 then Error:=Error+1;
    end
    else begin
      for j := 0 to Length(Answer)-1 do
        StringGridAnswer.Cells[j+k+2,i]:=FloatToStr(Answer[j]*StrToFloat(StringGridTrain.Cells[j+k+1,0]));
      StringGridAnswer.Cells[StringGridAnswer.ColCount-1,i]:=FloatToStr(StringGridAnswer.Cells[StringGridAnswer.ColCount-2,i].ToDouble-StringGridAnswer.Cells[StringGridAnswer.ColCount-3,i].ToDouble);
      Error:=Error+Abs(StringGridAnswer.Cells[StringGridAnswer.ColCount-2,i].ToDouble-StringGridAnswer.Cells[StringGridAnswer.ColCount-3,i].ToDouble);
    end;

  end;
    Memo1.Lines.Add(FloatToStr(Error/StringGridAnswer.RowCount));

end;

procedure TForm2.ButtonInitClick(Sender: TObject);
var
  Layers:array of Integer;
  Temp:TStrings;
  i,k: Integer;
begin
  Temp:=TStringList.Create;
  Temp.Delimiter:=',';
  Temp.DelimitedText:=Edit2.Text;
  SetLength(Layers,Temp.Count+2);
  for i := 0 to Temp.Count-1 do
    Layers[i+1]:=StrToInt(Temp[i]);
  k:=0;
  for i := 0 to StringGridTrain.ColCount-1 do
    if StringGridTrain.Cells[i,0]='' then begin k:=i;break;end;

  Layers[0]:=k;
//  Layers[Length(Layers)-1]:=AnswerMax;
  if EditFile.Text='trainhand.csv' then
    Layers[Length(Layers)-1]:=10
  else
    Layers[Length(Layers)-1]:=StringGridTrain.ColCount-1-k;
  if AI<>nil then AI.Free;
//  if EditFile.Text='trainhand.csv' then
//    AI:=NetWork.Creat(Layers,1)
//  else
    AI:=Network.Creat(Layers,2);
end;

end.
