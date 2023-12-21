unit Neural;

interface

uses Windows,System.Classes,System.Sysutils;

type
  array2D=array of array of Real;
  array1D=array of Real;

  FullConnectedLayer=class
  private
    input_size:Integer;
    output_size:Integer;
    b_grad:array1D;
    w_grad:array2D;
    delta:array1D;
  public
    activatorfun:Integer;
    weights:array2D;
    bias:array1D;
    output:array1D;
    input:array1D;
    Rate:Real;
    Error,Error1,Error2:Real;
    constructor Creat(Input:Integer;OutPut:Integer;activator:Integer);
    destructor  Destroy;
    procedure CalForword(Input:array1D);
    procedure CalBackword(deltaforword:array1D);
    procedure UpdateWeights(SRate:Real);
  end;

  Network=class
  private
    Layers_size:Integer;
  public
    error,error1:Real;
    errorcount:Integer;
    Layers:array of FullConnectedLayer;
    SRate:Real;
    constructor Creat(l:array of Integer;activator:Integer);
    destructor Destroy;
    function predict(input:array1D):array1D;
    function calc_gradient(answer:array1D):array1D;
    procedure UpdateWeights;
    procedure train_one_sample(simple:array1D;answer:array1D);
    procedure train(simple:array2D;answer:array2D;epoch:Integer;Rate:Real);
    procedure Save(F:String);
  end;

  function sigmoid(x:real;t:Boolean=true):real;
implementation


function sigmoid(x:real;t:Boolean):real;
begin
  if t then
  begin
    if x<-709 then
      result:=0
    else if x>709 then
      result:=1
    else
      result:=1/(1+exp(-x))
  end
  else
    Result:=x*(1-x);
end;

constructor FullConnectedLayer.Creat(Input:Integer;OutPut:Integer;activator:Integer);
var
  i: Integer;
  j: Integer;
begin
  Randomize;
  input_size:=Input;
  output_size:=OutPut;
  activatorfun:=activator;
  SetLength(weights,input_size,output_size);
  SetLength(bias,output_size);
  SetLength(w_grad,input_size,output_size);
  SetLength(b_grad,output_size);
  SetLength(delta,input_size);
  SetLength(self.output,self.output_size);
  activatorfun:=activator;
  for i := 0 to Input_size-1 do
  begin
    SetLength(weights[i],output_size);
    for j := 0 to output_size-1 do
      weights[i][j]:=random*2-1;
  end;
  Rate:=0.1/Input_Size/Output_Size;
end;

destructor FullConnectedLayer.Destroy;
begin
  inherited;
end;

procedure FullConnectedLayer.CalForword(Input: array1D);
var i,j:Integer;
begin
  Self.input:=Copy(Input);
  for i:=0 to output_size-1 do
  begin
    output[i]:=0;
    for j := 0 to input_size-1 do
      output[i]:=output[i]+Input[j]*weights[j,i]+bias[i];
//    output[i]:=output[i]+bias[i];
    case activatorfun of
      1:output[i]:=sigmoid(output[i]);
//      2:output[i]:=output[i];
    end;
  end;
end;

procedure FullConnectedLayer.CalBackword(deltaforword: array1D);
var
  i: Integer;
  j: Integer;
begin
  b_grad:=Copy(deltaforword);
//  Error1:=Error;
//  Error:=0;
  for i := 0 to input_size-1 do
  begin
    delta[i]:=0;
    for j := 0 to output_size-1 do
    begin
      delta[i]:=delta[i]+deltaforword[j]*weights[i,j];
      w_grad[i,j]:=deltaforword[j]*input[i];
    end;
    case activatorfun of
      1:delta[i]:=delta[i]*sigmoid(input[i],false);
//      2:delta[i]:=delta[i];//input[i];
    end;
//    Error:=Error+Sqr(delta[i]);
  end;
//  Error:=Sqrt(Error);
//  if  (Error1>0) and (Error1<=Error) then
//    Error2:=Error2+1
//  else
//    Error2:=0;
//  if Error2>4 then
//  begin
//    rate:=rate*0.618;
//    Error2:=0;
//    Error1:=0;
//    Error:=0;
//  end;

end;

procedure FullConnectedLayer.UpdateWeights(SRate:Real);
var
  I,j: Integer;
begin
  for j := 0 to output_size-1 do
  begin
    for I := 0 to input_size-1 do
      weights[i,j]:=weights[i,j]+rate*SRate*w_grad[i,j];
    bias[j]:=bias[j]+Self.rate*SRate*b_grad[j];
  end;
end;

constructor Network.Creat(l: array of Integer; activator: Integer);
var
  i: Integer;
begin
  Layers_size:=Length(l)-1;
  SetLength(Layers,Layers_size);
  for i := 0 to Layers_size-2 do
    Layers[i]:=FullConnectedLayer.Creat(l[i],l[i+1],activator);
  Layers[Layers_size-1]:=FullConnectedLayer.Creat(l[Layers_size-1],l[Layers_size],2);
  SRate:=1;
end;

destructor Network.Destroy;
begin
  inherited;
end;

function Network.predict(input: array1D):array1D;
var i:Integer;
begin
  Result:=Copy(input);
  for I := 0 to Length(Layers)-1 do
  begin
    Layers[i].CalForword(Result);
//    freemem(p);
    Result:=array1D(Layers[i].output);
  end;

end;

function Network.calc_gradient(answer: array1D):array1D;
var
  i: Integer;
begin
  SetLength(Result,Length(answer));
  error1:=0;
  for i := 0 to Length(answer)-1 do
  begin
    Result[i]:=(Answer[i]-Layers[Length(Layers)-1].output[i]);//(Layers[Length(Layers)-1].output[i]);
    error1:=error1+Sqr(Result[i]);
  end;
  error1:=Sqrt(error1);
//    Result[i]:=(Answer[i]-Layers[Length(Layers)-1].output[i])*sigmoid(Layers[Length(Layers)-1].output[i],false);
  for i := Length(Layers)-1 downto 0 do
  begin
    Layers[i].CalBackword(Result);
    Result:=Copy(Layers[i].delta);
  end;
end;

procedure Network.UpdateWeights;
var
  i: Integer;
begin
  for i := 0 to Length(Layers)-1 do
    Layers[i].UpdateWeights(SRate);
end;

procedure Network.train_one_sample(simple: array1D; answer: array1D);
begin
  predict(simple);
  calc_gradient(Answer);
  UpdateWeights;

end;



procedure Network.train(simple: array2D; answer: array2D; epoch: Integer;Rate:Real);
var
  i,j: Integer;
  LastError:Real;
begin
//  Self.SRate:=Rate;

  for i := 1 to epoch do
  begin
    LastError:=Error;
    Error:=0;
    for j := 0 to Length(answer)-1 do
    begin
      train_one_sample(Array1D(simple[j]),Array1D(answer[j]));
      error:=error+error1;
    end;
    if (LastError>0) and (LastError/Error<=1) then
      errorcount:=errorcount+1
    else
      errorcount:=0;
    if Errorcount>5 then
    begin
      Srate:=Srate*0.1;
      ErrorCount:=0;
    end;
  end;
end;

procedure Network.Save(F:String);
var
  Temp:TStrings;
  i: Integer;
  S:String;
  fi:File of Network;
begin
  Temp:=TStringList.Create;
  S:=IntToStr(Layers[0].input_size);
  for i := 0 to Length(Layers)-1 do
    S:=S+','+IntToStr(Layers[i].output_size);
  Temp.Add(S);
//  for i := 0 to Length(Layers)-1 do
//

end;

end.
