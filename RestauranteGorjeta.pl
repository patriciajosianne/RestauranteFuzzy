% Autor:    Guilherme e Patrícia
% Data: 05/04/2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funções Auxiliares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












%Retorna o tamanho de uma lista
tamanho([],Resultado) :- Resultado is 0.
tamanho([A | B],Resultado) :- tamanho(B,R), Resultado is R + 1.

%Retorna o maior elemento de uma lista
max([],Resultado) :- Resultado is -10000.
max([A | B],Resultado) :- max(B, R), (A >= R, Resultado is A ; Resultado is R), !.

%Retorna o menor elemento de uma lista
min([],Resultado) :- Resultado is 100000.
min([A | B],Resultado) :- min(B, R), (A >= R, Resultado is R ; Resultado is A), !.











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funções de Pertinência
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

triangular(X,[A,B,C],Resultado) :- min([(X-A)/(B-A), (C-X)/(C-B)], M), max([M,0],R), Resultado is R.
trapezoidal(X,[A,B,C,D],Resultado) :- min([(X-A)/(B-A), 1, (D-X)/(D-C)], M),  max([M,0],R), Resultado is R.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula o centro de um polígono
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

centroideA(Tam,Conj,[],Resultado) :- Resultado is 0.
centroideA(Tam,Conj,[A | B],Resultado) :-
     centroideA(Tam, Conj, B, Res),
     (Tam =:= 4, trapezoidal(A,Conj,Tmp),! ; triangular(A,Conj,Tmp),!),
     Resultado is Res + A*Tmp.

centroideB(Tam, Conj,[],Resultado) :- Resultado is 0.
centroideB(Tam, Conj,[A | B],Resultado) :-
     centroideB(Tam, Conj, B, Res),
     (Tam =:= 4, trapezoidal(A,Conj,Tmp),! ; triangular(A,Conj,Tmp),!),
     Resultado is Res + Tmp.

centroide(Conj, Resultado) :-
     tamanho(Conj, Tam),
     centroideA(Tam,Conj,Conj,A),
     centroideB(Tam,Conj,Conj,B),
     (B > 0, Resultado is A / B ; Resultado is 0).







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conjuntos Fuzzy     -     ATENDIMENTO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Delimitação dos conjuntos
ruimA([0,0.1,3,4]).
bomA([3,5.5,8]).
excelenteA([7,8,9.9,10]).


%Funções de pertinência para cada conjunto
fn_ruimA(X,P) :- ruimA(Conj), trapezoidal(X,Conj,P).
fn_bomA(X,P) :- bomA(Conj), triangular(X,Conj,P).
fn_excelenteA(X,P) :- excelenteA(Conj), trapezoidal(X,Conj,P).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conjuntos Fuzzy     -          COMIDA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Delimitação dos conjuntos
ruimC([0,0.1,3,4]).
bomC([3,5.5,8]).
excelenteC([7,8,9.9,10]).


%Funções de pertinência para cada conjunto
fn_ruimC(X,P) :- ruimC(Conj), trapezoidal(X,Conj,P).
fn_bomC(X,P) :- bomC(Conj), triangular(X,Conj,P).
fn_excelenteC(X,P) :- excelenteC(Conj), trapezoidal(X,Conj,P).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conjuntos Fuzzy     -         GORJETA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Delimitação dos conjuntos
gorjetaR([0,0.1,4,5]).
gorjteaB([4,7.5,11]).
gorjetaE([10,11,14.9,15]).

%Funções de pertinência para cada conjunto
fn_ruimG(X,P) :- ruimG(Conj), trapezoidal(X,Conj,P).
fn_bomG(X,P) :- bomG(Conj), triangular(X,Conj,P).
fn_excelenteG(X,P) :- excelenteG(Conj), trapezoidal(X,Conj,P).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variável Linquística
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      l.0

atendimento(X,Pertinencia) :- fn_ruimA(X,ruimA), fn_bomA(X,bomA), fn_excelenteA(X,excelenteA) Pertinencia = [ruimA,bomA,excelenteA].
comida(X,Pertinencia) :- fn_ruimC(X,ruimC), fn_bomC(X,bomC), fn_excelenteC(X,excelenteC) Pertinencia = [ruimC,bomC,excelenteC].





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regras de inferência e implicação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%SE atendimento = Ruim e comida = Ruim ENTAO Gorjeta = Ruim.
regra1([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoR,ComidaR,Tmp), GorjetaR is Tmp.
%SE atendimento = Ruim e comida = Bom ENTAO Gorjeta = Ruim.
regra2([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoR,ComidaB,Tmp), GorjetaR is Tmp.



%SE atendimento = Bom e comida = Ruim ENTAO Gorjeta = Bom.
regra3([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoB,ComidaR,Tmp), GorjetaB is Tmp.
%SE atendimento = Bom e comida = Bom ENTAO Gorjeta = Bom.
regra4([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoB,ComidaB,Tmp), GorjetaB is Tmp.
%SE atendimento = Excelente e comida = Ruim ENTAO Gorjeta = Bom.
regra5([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoE,ComidaR,Tmp), GorjetaB is Tmp.



%SE atendimento = Excelente e comida = Bom ENTAO Gorjeta = Excelente.
regra6([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoE,ComidaB,Tmp), GorjetaE is Tmp.
%SE atendimento = Bom e comida = Excelente ENTAO Gorjeta = Excelente.
regra7([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoB,ComidaE,Tmp), GorjetaE is Tmp.
%SE atendimento = Excelente e comida = Excelente ENTAO Gorjeta = Excelente.
regra8([AtendimentoR,AtendimentoB,AtendimentoE],[ComidaR,ComidaB,ComidaE],[GorjetaR,GorjetaB,GorjetaE]) :- min(AtendimentoE,ComidaE,Tmp), GorjetaE is Tmp.












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Defuzzyficação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

defuzzyficacao([PGorjeta1R,PGorjeta2R,PGorjeta3B,PGorjeta4B,PGorjeta5B,PGorjeta6E,PGorjeta7E,PGorjeta8E],PGorjetaF) :-
       /*frio(Frio),centroide(Frio,FrOut),
       fresco(Fresco),centroide(Fresco,FcOut),
       morno(Morno),centroide(Morno,MOut),
       quente(Quente),centroide(Quente,QOut),
       Resultado is FrOut*Fr + Fc*FcOut + M*MOut + Q*QOut, !.*/


       gorjetaR(GRuim),centroide(GRuim,GROut),
       gorjetaB(GBom),centroide(GBom,GBOut),
       gorjetaE(GExcelente),centroide(GExcelente,GEOut),

       
       Resultado is GROut*PGorjeta1R + GROut *PGorjeta2R + GBOut*PGorjeta3B + GBOut*PGorjeta4B + GBOut*PGorjeta5B + GEOut*PGorjeta6E + GEOut*PGorjeta7E +
       GEOut*PGorjeta8E, !.





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador fuzzy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

controladorFuzzy(NotaAtendimento,NotaComida,NotaGorjeta) :-

      %Fuzzyficação
      atendimento(NotaAtendimento, PAtendimento),
      comida(NotaComida, PComida),

      % Inferência - Implicação e Agregação
      regra1(PAtendimento,PComida, PGorjeta1R),
      regra2(PAtendimento,PComida, PGorjeta2R),
      regra3(PAtendimento,PComida, PGorjeta3B),
      regra4(PAtendimento,PComida, PGorjeta4B),
      regra5(PAtendimento,PComida, PGorjeta5B),
      regra6(PAtendimento,PComida, PGorjeta6E),
      regra7(PAtendimento,PComida, PGorjeta7E),
      regra8(PAtendimento,PComida, PGorjeta8E),

      %Defuzzyficação
      defuzzyficacao([PGorjeta1R,PGorjeta2R,PGorjeta3B,PGorjeta4B,PGorjeta5B,PGorjeta6E,PGorjeta7E,PGorjeta8E],PGorjetaF), !.