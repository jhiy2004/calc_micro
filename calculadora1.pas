unit Calculadora1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel;
  //RTTICtrls;

type
    No = record
       caractere: Char;
       prox: ^No;
    end;

    Lista = record
       inicio: ^No;
       count : Integer;
    end;

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
    procedure cosClick(Sender: TObject);
    procedure diviClick(Sender: TObject);
    procedure DoisClick(Sender: TObject);
    procedure DisplayChange(Sender: TObject);
    procedure equalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InvClick(Sender: TObject);
    procedure leftPairClick(Sender: TObject);
    procedure lnClick(Sender: TObject);
    procedure logClick(Sender: TObject);
    procedure minusClick(Sender: TObject);
    procedure mulClick(Sender: TObject);
    procedure nfatClick(Sender: TObject);
    procedure noveClick(Sender: TObject);
    procedure oitoClick(Sender: TObject);
    procedure piClick(Sender: TObject);
    procedure plusClick(Sender: TObject);
    procedure quatroClick(Sender: TObject);
    procedure rightPairClick(Sender: TObject);
    procedure seisClick(Sender: TObject);
    procedure seteClick(Sender: TObject);
    procedure sinClick(Sender: TObject);
    procedure tanClick(Sender: TObject);
    procedure tresClick(Sender: TObject);
    procedure UmClick(Sender: TObject);
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
implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  exprVisor := '0';
end;

procedure TForm1.InvClick(Sender: TObject);
begin
  if (Inv.Checked) then
  begin
     cos.Caption := 'arccos';
     sin.Caption := 'arcsen';
     tan.Caption := 'arcstg';
  end
  else
  begin
     cos.Caption := 'cos';
     sin.Caption := 'sen';
     tan.Caption := 'tg';
  end;
end;

procedure inicializarLista(var lista : Lista);
begin
  lista.inicio := nil;
  lista.count := 0;
end;

function precedencia(op : string) : integer;
begin
  if((op = 'sin') or (op = 'cos') or (op = 'tg') or (op = 'arcsen') or (op = 'arccos') or (op = 'arctg')) then
  begin
     Result := 4;
  end
  else if((op = 'log') or (op = 'ln')) then
  begin
     Result := 4;
  end
  else if((op = '~')) then
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
  temp := '';
  for elemento in exprVisor do
  begin
     if (elemento = '+') or (elemento = '-') or (elemento = '*') or (elemento = '/') or (elemento = '^') or (elemento = '!') or (elemento = '(') or (elemento = ')') then
     begin
        if temp <> '' then
        begin
           if ((temp[1] >= '0') and (temp[1] <= '9')) then
           begin
              polonesa[polonesaIndex] := temp;
              inc(polonesaIndex);
           end
           else
           begin
              while((pilhaIndex >= 0) and (precedencia(temp) < precedencia(pilha[pilhaIndex])) or (precedencia(temp) = precedencia(pilha[pilhaIndex])) and (associatividade(temp) = 0)) do
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
           pilha[pilhaIndex] := elemento;
           inc(pilhaIndex);
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
           while((pilhaIndex >= 0) and (precedencia(elemento) < precedencia(pilha[pilhaIndex])) or (precedencia(elemento) = precedencia(pilha[pilhaIndex])) and (associatividade(elemento) = 0)) do
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
  resultado : real;
  euler : real;
begin
  euler := 2.718281828459045;
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
     fstp resultado
  end;
  Result := resultado;
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
begin
  {$ASMMODE intel}
  asm

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
  euler := 2.718281828459045;
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
var
  resultado : real;
begin
  {$ASMMODE intel}
  asm
     finit
     fld x
     fcos
     fstp resultado
  end;
  Result := resultado;
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
  Result := arcoTangenteRadiano(resultado);
end;

function arcoCossenoGraus(x : real): real;
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
  Result := arcoTangenteGraus(resultado);
end;








procedure EscreverExpr(x: string);
begin
  if(exprVisor = '0') then
  begin
    exprVisor := x;
  end
  else
  begin
    exprVisor := exprVisor+x;
  end;
end;

procedure TForm1.leftPairClick(Sender: TObject);
begin
  EscreverExpr('(');
  Display.Text := exprVisor;
end;

procedure TForm1.lnClick(Sender: TObject);
begin
  EscreverExpr('ln(');
  Display.Text := exprVisor;
end;

procedure TForm1.logClick(Sender: TObject);
var teste : real;
begin
  teste := arcoCossenoRadiano(1);
  Display.Text := FloatToStr(teste);
  //EscreverExpr('log(');
  //Display.Text := exprVisor;
end;

procedure TForm1.minusClick(Sender: TObject);
begin
  EscreverExpr('-');
  Display.Text := exprVisor;
end;

procedure TForm1.mulClick(Sender: TObject);
begin
  EscreverExpr('*');
  Display.Text := exprVisor;
end;

procedure TForm1.nfatClick(Sender: TObject);
begin
  EscreverExpr('!');
  Display.Text := exprVisor;
end;

procedure TForm1.noveClick(Sender: TObject);
begin
  EscreverExpr('9');
  Display.Text := exprVisor;
end;

procedure TForm1.oitoClick(Sender: TObject);
begin
  EscreverExpr('8');
  Display.Text := exprVisor;
end;

procedure TForm1.piClick(Sender: TObject);
begin
  EscreverExpr('π');
  Display.Text := exprVisor;
end;

procedure TForm1.plusClick(Sender: TObject);
begin
  EscreverExpr('+');
  Display.Text := exprVisor;
end;

procedure TForm1.quatroClick(Sender: TObject);
begin
  EscreverExpr('4');
  Display.Text := exprVisor;
end;

procedure TForm1.rightPairClick(Sender: TObject);
begin
  EscreverExpr(')');
  Display.Text := exprVisor;
end;

procedure TForm1.seisClick(Sender: TObject);
begin
  EscreverExpr('6');
  Display.Text := exprVisor;
end;

procedure TForm1.seteClick(Sender: TObject);
begin
  EscreverExpr('7');
  Display.Text := exprVisor;
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
  Display.Text := exprVisor;
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
  Display.Text := exprVisor;
end;

procedure TForm1.tresClick(Sender: TObject);
begin
  EscreverExpr('3');
  Display.Text := exprVisor;
end;

procedure TForm1.UmClick(Sender: TObject);
begin
  EscreverExpr('1');
  Display.Text := exprVisor;
end;

procedure TForm1.xYClick(Sender: TObject);
begin
  EscreverExpr('^');
  Display.Text := exprVisor;
end;

procedure TForm1.zeroClick(Sender: TObject);
begin
  EscreverExpr('0');
  Display.Text := exprVisor;
end;

procedure TForm1.DisplayChange(Sender: TObject);
begin

end;

procedure TForm1.equalClick(Sender: TObject);
var
  elemento:string;
begin
  converterParaPolonesa();
  for elemento in polonesa do
  begin
     if elemento <> '' then
        exprVisor := exprVisor + '|' + elemento;
  end;
  EscreverExpr('=');
  Display.Text := exprVisor;
end;

procedure TForm1.CClick(Sender: TObject);
var textoTela : String;
begin
     textoTela := Display.Text;

     if Length(textoTela) > 0 then
        begin
          textoTela := Copy(textoTela, 1, Length(textoTela) - 1);
          Display.text := textoTela;
        end;

end;

procedure TForm1.CEClick(Sender: TObject);
begin
  exprVisor := '0';
  Display.Text := exprVisor;
end;

procedure TForm1.cincoClick(Sender: TObject);
begin
  EscreverExpr('5');
  Display.Text := exprVisor;
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
  Display.Text := exprVisor;
end;

procedure TForm1.diviClick(Sender: TObject);
var resu : real;
begin
  EscreverExpr('/');
  Display.Text := exprVisor;
end;

procedure TForm1.DoisClick(Sender: TObject);
begin
  EscreverExpr('2');
  Display.Text := exprVisor;
end;




end.

