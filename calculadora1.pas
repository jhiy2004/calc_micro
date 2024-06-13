unit Calculadora1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel;
  //RTTICtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    leftPair: TButton;
    rightPair: TButton;
    Inv: TCheckBox;
    oneDivX: TButton;
    C: TButton;
    CE: TButton;
    Display: TEdit;
    nfat: TButton;
    nove: TButton;
    divi: TButton;
    cos: TButton;
    xY: TButton;
    quatro: TButton;
    cinco: TButton;
    seis: TButton;
    mul: TButton;
    tan: TButton;
    log: TButton;
    xSquare: TButton;
    um: TButton;
    dois: TButton;
    tres: TButton;
    minus: TButton;
    rootYofX: TButton;
    eX27: TButton;
    pi: TButton;
    zero: TButton;
    ln: TButton;
    plusMinus: TButton;
    comma: TButton;
    plus: TButton;
    equal: TButton;
    sin: TButton;
    eX: TButton;
    sete: TButton;
    oito: TButton;
    Graus: TRadioButton;
    Radianos: TRadioButton;
    procedure CClick(Sender: TObject);
    procedure CEClick(Sender: TObject);
    procedure cincoClick(Sender: TObject);
    procedure commaClick(Sender: TObject);
    procedure cosClick(Sender: TObject);
    procedure diviClick(Sender: TObject);
    procedure DoisClick(Sender: TObject);
    procedure DisplayChange(Sender: TObject);
    procedure equalClick(Sender: TObject);
    procedure eX27Click(Sender: TObject);
    procedure eXClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GrausClick(Sender: TObject);
    procedure InvClick(Sender: TObject);
    procedure leftPairClick(Sender: TObject);
    procedure lnClick(Sender: TObject);
    procedure logClick(Sender: TObject);
    procedure minusClick(Sender: TObject);
    procedure mulClick(Sender: TObject);
    procedure nfatClick(Sender: TObject);
    procedure noveClick(Sender: TObject);
    procedure oitoClick(Sender: TObject);
    procedure oneDivXClick(Sender: TObject);
    procedure piClick(Sender: TObject);
    procedure plusClick(Sender: TObject);
    procedure plusMinusClick(Sender: TObject);
    procedure quatroClick(Sender: TObject);
    procedure RadianosClick(Sender: TObject);
    procedure rightPairClick(Sender: TObject);
    procedure rootYofXClick(Sender: TObject);
    procedure seisClick(Sender: TObject);
    procedure seteClick(Sender: TObject);
    procedure sinClick(Sender: TObject);
    procedure tanClick(Sender: TObject);
    procedure tresClick(Sender: TObject);
    procedure UmClick(Sender: TObject);
    procedure xSquareClick(Sender: TObject);
    procedure xYClick(Sender: TObject);
    procedure zeroClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  exprVisor: string;
  polonesa: array[0..300] of string;
  polonesaIndex: integer;
  pilha: array[0..300] of string;
  pilhaIndex: integer;
  radianosChecked: boolean;
implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  exprVisor := '';
end;

procedure TForm1.GrausClick(Sender: TObject);
begin
  radianosChecked := false;
end;

procedure TForm1.InvClick(Sender: TObject);
begin
  if (Inv.Checked) then
  begin
     cos.Caption := 'arccos';
     sin.Caption := 'arcsen';
     tan.Caption := 'arctg';
  end
  else
  begin
     cos.Caption := 'cos';
     sin.Caption := 'sen';
     tan.Caption := 'tg';
  end;
end;

function precedencia(op : string) : integer;
begin
  if((op = 'sin') or (op = 'cos') or (op = 'tg') or (op = 'arcsen') or (op = 'arccos') or (op = 'arctg')) then
  begin
     Result := 6;
  end
  else if((op = 'log') or (op = 'ln')) then
  begin
     Result := 6;
  end
  else if((op = '~')) then
  begin
     Result := 5;
  end
  else if((op = '!')) then
  begin
     Result := 4;
  end
  else if((op = '^') or (op = '√')) then
  begin
     Result := 3;
  end
  else if((op = '*') or (op = '/')) then
  begin
     Result := 2;
  end
  else if ((op = '+') or (op = '-')) then
  begin
     Result := 1;
  end
  else
  begin
     Result := -1;
  end;
end;

function associatividade(c:string):integer;
begin
   if(c = '^') then
   begin
      Result := 1;
   end
   else
   begin
      Result := 0;
   end;
end;

procedure converterParaPolonesa();
var
  elemento:string;
  temp:string;
begin
  pilhaIndex := -1;
  polonesaIndex := 0;
  temp := '';
  for elemento in exprVisor do
  begin
     if (elemento = '~') or (elemento = '+') or (elemento = '-') or (elemento = '*') or (elemento = '/') or (elemento = '^') or (elemento = '!') or (elemento = '(') or (elemento = ')') then
     begin
        if temp <> '' then
        begin
           if ((temp[1] >= '0') and (temp[1] <= '9')) or ((temp = 'π')) or ((temp = 'e')) then
           begin
              if ((temp = 'π')) then
              begin
                 temp := '3,14159265358979323846';
              end;
              if((temp = 'e')) then
              begin
                 temp := '2,71828182845904523536';
              end;
              polonesa[polonesaIndex] := temp;
              inc(polonesaIndex);
           end
           else
           begin
              while ((pilhaIndex >= 0) and ((precedencia(temp) < precedencia(pilha[pilhaIndex])) or (precedencia(temp) = precedencia(pilha[pilhaIndex])) and (associatividade(temp) = 0))) do
              begin
                 polonesa[polonesaIndex] := pilha[pilhaIndex];
                 inc(polonesaIndex);
                 dec(pilhaIndex);
              end;
              inc(pilhaIndex);
              pilha[pilhaIndex] := temp;
           end;
        end;
        temp := '';
        if elemento = '(' then
        begin
           inc(pilhaIndex);
           pilha[pilhaIndex] := elemento;
        end
        else if elemento = ')' then
        begin
           while ((pilhaIndex >= 0) and (pilha[pilhaIndex] <> '(')) do
           begin
              polonesa[polonesaIndex] := pilha[pilhaIndex];
              inc(polonesaIndex);
              dec(pilhaIndex);
           end;
           dec(pilhaIndex);
        end
        else
        begin
           while ((pilhaIndex >= 0) and ((precedencia(elemento) < precedencia(pilha[pilhaIndex])) or (precedencia(elemento) = precedencia(pilha[pilhaIndex])) and (associatividade(elemento) = 0))) do
           begin
              polonesa[polonesaIndex] := pilha[pilhaIndex];
              inc(polonesaIndex);
              dec(pilhaIndex);
           end;
           inc(pilhaIndex);
           pilha[pilhaIndex] := elemento;
        end;
     end
     else
     begin
        appendstr(temp, elemento);
     end;
  end;
  if (temp <> '') then
  begin
     if ((temp = 'π')) then
     begin
          temp := '3,14159265358979323846';
     end;
     if((temp = 'e')) then
     begin
          temp := '2,71828182845904523536';
     end;
     polonesa[polonesaIndex] := temp;
     inc(polonesaIndex);
  end;

  while (pilhaIndex >= 0) do
  begin
     polonesa[polonesaIndex] := pilha[pilhaIndex];
     inc(polonesaIndex);
     dec(pilhaIndex);
  end;
end;

function Soma(a, b : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld a
     fld b
     fadd
     fstp resultado
  end;
  Result := resultado;
end;

function Subtracao(a, b : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld a
     fld b
     fsub
     fstp resultado
  end;
  Result := resultado;
end;

function Multiplicacao(a, b : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld a
     fld b
     fmul
     fstp resultado
  end;
  Result := resultado;
end;

function Divisao(a, b : real): real;
var
  resultado : real;
begin
  if b <> 0 then
  begin
    {$ASMMODE intel}
    asm
       finit
       fld a
       fld b
       fdiv
       fstp resultado
    end;
    Result := resultado;
  end
  else
  begin
    Result := 0; // TRATAR ISSO
  end;
end;

function eulerElevadoX(x : real): real;
var
  euler : real;
begin
  euler := 2.71828182845904523536;
  {$ASMMODE intel}
  asm
     finit
     fld x
     fld1
     fld euler
     fyl2x
     fmul
     fld st
     frndint
     fsub st(1), st
     fxch
     f2xm1
     fld1
     fadd
     fscale
     fstp result
  end;
end;

function xElevadoY(x, y : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld y
     fld1
     fld x
     fyl2x
     fmul
     fld st
     frndint
     fsub st(1), st
     fxch
     f2xm1
     fld1
     fadd
     fscale
     fstp resultado
  end;
  Result := resultado;
end;

function xQuadrado(x : real): real;
var
  resultado : real;
  dois : real;
begin
  dois := 2;
  {$ASMMODE intel}
  asm
     finit
     fld dois
     fld1
     fld x
     fyl2x
     fmul
     fld st
     frndint
     fsub st(1), st
     fxch
     f2xm1
     fld1
     fadd
     fscale
     fstp resultado
  end;
  Result := resultado;
end;

function sqrtX(x : real): real;
var
  resultado : real;
begin;
  {$ASMMODE intel}
  asm
     finit
     fld x
     fsqrt
     fstp resultado
  end;
  Result := resultado;
end;

function yRootX(x, y: real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld y
     fdiv
     fld1
     fld x
     fyl2x
     fmul
     fld st
     frndint
     fsub st(1), st
     fxch
     f2xm1
     fld1
     fadd
     fscale
     fstp resultado
  end;
  Result := resultado;
end;

function fatorial(x : real): real;
var
  resultado : real;
  um : real;
  zero : real;
begin
  um := 1.0;
  zero := 0.0;
  {$ASMMODE intel}
  asm
     finit
     fld x
     fld x
     fcom um
     fstsw AX
     sahf
     je @fimfat
     fcom zero
     fstsw AX
     sahf
     je @fimzero
     @loop:
     fld1
     fsub
     fmul st(1), st
     fcom um
     fstsw AX
     sahf
     je @fimfat
     jmp @loop
     @fimfat:
     fxch
     fstp resultado
     jmp @final
     @fimzero:
     fld1
     fstp resultado
     @final:
  end;
  Result := resultado;
end;

function logaritmo(base, x : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld base
     fyl2x
     fld1
     fdiv st, st(1)
     fld x
     fyl2x
     fstp resultado
  end;
  Result := resultado;
end;

function logNeperiano(x : real): real;
var
  resultado : real;
  euler : real;
begin
  euler := 2.71828182845904523536;
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld euler
     fyl2x
     fld1
     fdiv st, st(1)
     fld x
     fyl2x
     fstp resultado
  end;
  Result := resultado;
end;

function umSobreX(x : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld x
     fdiv
     fstp resultado
  end;
  Result := resultado;
end;

function grauParaRadiano(x : real): real;
var
  resultado : real;
  cento_oitenta : real;
begin
  cento_oitenta := 180;
  {$ASMMODE intel}
  asm
     finit
     fld x
     fldpi
     fmul
     fld cento_oitenta
     fdiv
     fstp resultado
  end;
  Result := resultado;
end;

function senoRadiano(x : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fsin
     fstp resultado
  end;
  Result := resultado;
end;

function senoGraus(x : real): real;
var
  resultado : real;
  radianos : real;
begin
  radianos := grauParaRadiano(x);
  {$ASMMODE intel}
  asm
     finit
     fld radianos
     fsin
     fstp resultado
  end;
  Result := resultado;
end;

function cossenoRadiano(x : real): real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fcos
     fstp result
  end;
end;

function cossenoGraus(x : real): real;
var
  resultado : real;
  radianos : real;
begin
  radianos := grauParaRadiano(x);
  {$ASMMODE intel}
  asm
     finit
     fld radianos
     fcos
     fstp resultado
  end;
  Result := resultado;
end;

function tangenteRadiano(x : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fsin
     fld x
     fcos
     fdiv    // DEVEMOS VERIFICAR??
     fstp resultado
  end;
  Result := resultado;
end;

function tangenteGraus(x : real): real;
var
  resultado : real;
  radianos : real;
begin
  radianos := grauParaRadiano(x);
  {$ASMMODE intel}
  asm
     finit
     fld radianos
     fsin
     fld radianos
     fcos
     fdiv    // DEVEMOS VERIFICAR??
     fstp resultado
  end;
  Result := resultado;
end;

function arcoTangenteRadiano(x : real): real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fld1
     fpatan
     fstp resultado
  end;
  Result := resultado;
end;

function arcoTangenteGraus(x : real): real;
var
  resultado : real;
  cento_oitenta : real;
begin
  cento_oitenta := 180.0;
  {$ASMMODE intel}
  asm
     finit
     fld x
     fld1
     fpatan
     fld cento_oitenta
     fmul
     fldpi
     fdiv  // Transforma de radianos para graus
     fstp resultado
  end;
  Result := resultado;
end;

function arcoSenoRadiano(x : real): real;
var
  resultado: real;
begin
  // verificar se -1 <= x <= 1
  {$ASMMODE intel}
  asm
    finit
    fld1
    fld x
    fld x
    fmul
    fsub
    fsqrt
    fld x
    fdivr
    fstp resultado
  end;
  Result := arcoTangenteRadiano(resultado);
end;

function arcoSenoGraus(x : real): real;
var
  resultado: real;
begin
  // verificar se -1 <= x <= 1
  {$ASMMODE intel}
  asm
    finit
    fld1
    fld x
    fld x
    fmul
    fsub
    fsqrt
    fld x
    fdivr
    fstp resultado
  end;
  Result := arcoTangenteGraus(resultado);
end;

function arcoCossenoRadiano(x : real): real;
var
  resultado : real;
begin
  // verificar se -1 <= x <= 1
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld x
     fld x
     fmul
     fsub
     fsqrt
     fld x
     fdiv
     fstp resultado
  end;
  if resultado < 0.0 then
  begin
    Result := 3.14159265358979323846 + arcoTangenteRadiano(resultado);
  end
  else if x = -1 then
  begin
    Result := 3.14159265358979323846;
  end
  else
  begin
    Result := arcoTangenteRadiano(resultado);
  end;
end;

function arcoCossenoGraus(x : real): real;
var
  resultado : real;
  temp : real;
begin
  // verificar se -1 <= x <= 1
  {$ASMMODE intel}
  asm
     finit
     fld1
     fld x
     fld x
     fmul
     fsub
     fsqrt
     fld x
     fdiv
     fstp resultado
  end;
  if resultado < 0.0 then
  begin
    Result := 180.0 + arcoTangenteGraus(resultado);
  end
  else if x = -1 then
  begin
    Result := 180.0;
  end
  else
  begin
    Result := arcoTangenteGraus(resultado);
  end;
end;

function negativar(x : real) : real;
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fchs
     fstp resultado
  end;
  Result := resultado;
end;







procedure EscreverExpr(x: string);
begin
  if(Form1.Display.Text = '') then
  begin
    Form1.Display.Text := x;
  end
  else
  begin
    Form1.Display.Text := Form1.Display.Text+x;
  end;
end;

procedure TForm1.leftPairClick(Sender: TObject);
begin
  EscreverExpr('(');
end;

procedure TForm1.lnClick(Sender: TObject);
begin
  EscreverExpr('ln(');
end;

procedure TForm1.logClick(Sender: TObject);
begin
  EscreverExpr('log(');
end;

procedure TForm1.minusClick(Sender: TObject);
begin
  EscreverExpr('-');
end;

procedure TForm1.mulClick(Sender: TObject);
begin
  EscreverExpr('*');
end;

procedure TForm1.nfatClick(Sender: TObject);
begin
  EscreverExpr('!');
end;

procedure TForm1.noveClick(Sender: TObject);
begin
  EscreverExpr('9');
end;

procedure TForm1.oitoClick(Sender: TObject);
begin
  EscreverExpr('8');
end;

procedure TForm1.oneDivXClick(Sender: TObject);
begin
   EscreverExpr('1/');
end;

procedure TForm1.piClick(Sender: TObject);
begin
  EscreverExpr('π');
end;

procedure TForm1.plusClick(Sender: TObject);
begin
  EscreverExpr('+');
end;

procedure TForm1.plusMinusClick(Sender: TObject);
begin
  EscreverExpr('~');
end;

procedure TForm1.quatroClick(Sender: TObject);
begin
  EscreverExpr('4');
end;

procedure TForm1.RadianosClick(Sender: TObject);
begin
   radianosChecked := true;
end;

procedure TForm1.rightPairClick(Sender: TObject);
begin
  EscreverExpr(')');
end;

procedure TForm1.rootYofXClick(Sender: TObject);
begin
  EscreverExpr('^(1/');
end;

procedure TForm1.seisClick(Sender: TObject);
begin
  EscreverExpr('6');
end;

procedure TForm1.seteClick(Sender: TObject);
begin
  EscreverExpr('7');
end;

procedure TForm1.sinClick(Sender: TObject);
begin
  if(Inv.Checked) then
  begin
    EscreverExpr('arcsen(');
  end
  else
  begin
    EscreverExpr('sen(');
  end;
end;

procedure TForm1.tanClick(Sender: TObject);
begin
  if(Inv.Checked) then
  begin
    EscreverExpr('arctg(');
  end
  else
  begin
    EscreverExpr('tg(');
  end;
end;

procedure TForm1.tresClick(Sender: TObject);
begin
  EscreverExpr('3');
end;

procedure TForm1.UmClick(Sender: TObject);
begin
  EscreverExpr('1');
end;

procedure TForm1.xSquareClick(Sender: TObject);
begin
   EscreverExpr('^2');
end;

procedure TForm1.xYClick(Sender: TObject);
begin
  EscreverExpr('^');
end;

procedure TForm1.zeroClick(Sender: TObject);
begin
  EscreverExpr('0');
end;

procedure TForm1.DisplayChange(Sender: TObject);
begin

end;

procedure TForm1.CClick(Sender: TObject);
begin
  Display.Text := '';
end;

procedure TForm1.CEClick(Sender: TObject);
begin
  if Length(Display.Text) > 0 then
        begin
          Display.Text := Copy(Display.Text, 1, Length(Display.Text) - 1);
        end;
end;

procedure TForm1.cincoClick(Sender: TObject);
begin
  EscreverExpr('5');
end;

procedure TForm1.commaClick(Sender: TObject);
begin
  EscreverExpr(',');
end;

procedure TForm1.cosClick(Sender: TObject);
begin
  if(Inv.Checked) then
  begin
    EscreverExpr('arccos(');
  end
  else
  begin
    EscreverExpr('cos(');
  end;
end;

procedure TForm1.diviClick(Sender: TObject);
var resu : real;
begin
  EscreverExpr('/');
end;

procedure TForm1.DoisClick(Sender: TObject);
begin
  EscreverExpr('2');
end;

function processarPolonesa() : string;
var
  i : integer;
  temp : real;
  operandos : array[0..300] of real;
  operandosIndex : integer;
begin
  i := 0;
  operandosIndex := 0;
  while(i < polonesaIndex) do
  begin
    if(polonesa[i] = '+') then
    begin
      // Soma
      temp := Soma(operandos[operandosIndex-1], operandos[operandosIndex-2]);
      operandos[operandosIndex-1] := 0;
      operandos[operandosIndex-2] := temp;
      dec(operandosIndex);
    end
    else if(polonesa[i] = '-') then
    begin
      // Subtracao
      temp := Subtracao(operandos[operandosIndex-2], operandos[operandosIndex-1]);
      operandos[operandosIndex-1] := 0;
      operandos[operandosIndex-2] := temp;
      dec(operandosIndex);
    end
    else if(polonesa[i] = '*') then
    begin
      // Multiplicacao
      temp := Multiplicacao(operandos[operandosIndex-1], operandos[operandosIndex-2]);
      operandos[operandosIndex-1] := 0;
      operandos[operandosIndex-2] := temp;
      dec(operandosIndex);
    end
    else if(polonesa[i] = '/') then
    begin
      // Divisao
      temp := Divisao(operandos[operandosIndex-2], operandos[operandosIndex-1]);
      operandos[operandosIndex-1] := 0;
      operandos[operandosIndex-2] := temp;
      dec(operandosIndex);
    end
    else if(polonesa[i] = '^') then
    begin
      // Exponenciação
      temp := xElevadoY(operandos[operandosIndex-2], operandos[operandosIndex-1]);
      operandos[operandosIndex-1] := 0;
      operandos[operandosIndex-2] := temp;
      dec(operandosIndex);
    end
    else if(polonesa[i] = '~') then
    begin
      // Negativar
      temp := negativar(operandos[operandosIndex-1]);
      operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'sen') then
    begin
       if(radianosChecked) then
       begin
          temp := senoRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := senoGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'cos') then
    begin
       if(radianosChecked) then
       begin
          temp := cossenoRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := cossenoGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'tg') then
    begin
       if(radianosChecked) then
       begin
          temp := tangenteRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := tangenteGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'arcsen') then
    begin
       if(radianosChecked) then
       begin
          temp := arcoSenoRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := arcoSenoGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'arccos') then
    begin
       if(radianosChecked) then
       begin
          temp := arcoCossenoRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := arcoCossenoGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'arctg') then
    begin
       if(radianosChecked) then
       begin
          temp := arcoTangenteRadiano(operandos[operandosIndex-1]);
       end
       else
       begin
          temp := arcoTangenteGraus(operandos[operandosIndex-1]);
       end;
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = '!') then
    begin
       temp := fatorial(operandos[operandosIndex-1]);
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'log') then
    begin
       //Logaritmo
       temp := logaritmo(10, operandos[operandosIndex-1]);
       operandos[operandosIndex-1] := temp;
    end
    else if(polonesa[i] = 'ln') then
    begin
       //Logaritmo neperiano
       temp := logNeperiano(operandos[operandosIndex-1]);
       operandos[operandosIndex-1] := temp;
    end
    else if (polonesa[i] = '√') then
    begin
       temp := sqrtX(operandos[operandosIndex-1]);
       operandos[operandosIndex-1] := temp;
    end
    else
    begin
      operandos[operandosIndex] := StrToFloat(polonesa[i]);
      inc(operandosIndex);
    end;
    inc(i);
  end;
  Result := FloatToStr(operandos[0]);
end;

procedure TForm1.equalClick(Sender: TObject);
var
  teste:string;
  i:integer;
begin
  exprVisor := Display.Text;
  converterParaPolonesa();
  (*for i := 0 to polonesaIndex do
  begin
     if polonesa[i] <> '' then
        if((polonesa[i][1] >= '0') and (polonesa[i][1] <= '9')) then
        begin
           teste := teste + '`' + FloatToStr(StrToFloat(polonesa[i]));
        end
        else
        begin
           teste := teste + '|' + polonesa[i];
        end;
  end;
  Display.Text := teste;*)
  Display.Text := processarPolonesa();
end;

procedure TForm1.eX27Click(Sender: TObject);
begin
  EscreverExpr('√(');
end;

procedure TForm1.eXClick(Sender: TObject);
begin
  EscreverExpr('e^');
end;



end.

