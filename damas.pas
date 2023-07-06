program DibujarMatriz;
uses Crt;

const
  FILAS = 8;
  COLUMNAS = 8;
  BLANCA = 'x';
  NEGRA = 'o';
  CANT_FICHAS = 12;
  C: array[1..9] of string = ('┐', '┌', '┘', '└', '─', '│', ' ', '┼', '░');

type
  matriz= array[1..FILAS, 1..COLUMNAS] of char;
  arrpos= array[1..2] of integer;

var
  mat: matriz;

function FondoNegro(fila,col:integer):boolean;
// Retorna verdadero/falso dependiendo del fondo que tiene la celda (damero).
begin
    FondoNegro := (((fila+col) mod 2) = 1);
end;
function CantFichasEnTablero(mat:matriz; color:char):integer;
var cant, fila, columna:integer;
begin
    cant := 0;
    for fila := 1 to FILAS do
        for columna := 1 to COLUMNAS do
            if mat[fila,columna] = color then
                cant := cant + 1;
    CantFichasEnTablero := cant;
end;
procedure InicMatriz(var mat:matriz);
// Inicializa la matriz con las 64 celdas en blanco.
var
  i, j: integer;
begin
for i:=1 to FILAS do 
    for j:=1 to COLUMNAS do
        mat[i,j] := ' ';
end;
procedure CargarFichas(var mat:matriz; color:char; cantidad:integer);
// Carga la matriz con las 16 fichas en su posicion inicial.
var fila_inicial: integer;
    incremento:integer;
    fila, columna:integer;
    fichas: integer;
begin
    if color=NEGRA then begin
        fila_inicial := 1;
        incremento := 1;
        columna := 2;
    end else begin
        fila_inicial := FILAS;
        incremento := -1;
        columna := 1;
    end;
    fila := fila_inicial;
    for fichas:= 1 to CANT_FICHAS do begin
        if not(FondoNegro(fila, columna)) then
            columna := columna + 1;
        mat[fila, columna] := color;
        columna := columna + 2;
        if columna > COLUMNAS then begin
            columna := 1;
            fila := fila + incremento;
        end;
    end;
end;
procedure DibujarMatriz(mat:matriz);
// Muestra la matriz por pantalla.
var
  i, j: integer;
begin
    ClrScr;  // Blanquea la pantalla.
    write(' ',C[2]);
    for j:=1 to COLUMNAS do write(C[5],C[5],C[5]);
    writeln(C[1]);
    for i:=1 to FILAS do begin
        write(' ',C[6]);
        for j:=1 to COLUMNAS do begin
            if not(FondoNegro(i,j)) then
                write(C[9],C[9],C[9])
            else
                write(' ',mat[i,j],' ');
        end;
        writeln(C[6]);
    end;
    write(' ',C[4]);
    for j:=1 to COLUMNAS do write(C[5],C[5],C[5]);
    writeln(C[3]);
    for i := 1 to CANT_FICHAS - CantFichasEnTablero(mat,NEGRA) do write(NEGRA); writeln();
    for i := 1 to CANT_FICHAS - CantFichasEnTablero(mat,BLANCA) do write(BLANCA); writeln();
end;


function perdio(color:char):boolean;
var jugador:char;
begin

jugador:=color;

if cantfichasentablero(mat,jugador)<>0 then
    perdio:=false
else
    perdio:=true;
    
end;

function seleccionarpos(mat:matriz;color:char;var fila,columna:integer):arrpos;
begin

    writeln('ingrese fila de ficha a mover');
    readln(fila);
    writeln('ingrese columna de ficha a mover');
    readln(columna);
    
    if (fila<=FILAS) and (columna<=COLUMNAS) then
        begin
        if (mat[fila,columna]=color) then begin
            seleccionarpos[1]:=fila;
            seleccionarpos[2]:=columna; 
        end
        else 
            writeln('la posicion elegida no tiene una ficha del tipo:',color);
        end
    else
        writeln('la posicion es invalida');


end;

function seleccionarnpos(var nfila,ncol:integer):arrpos;
begin
    writeln('seleccionar fila de la nueva posicion');
    readln(nfila);
    writeln('seleccionar columna de la nueva posicion');
    readln(ncol);
    
    seleccionarnpos[1]:=nfila;
    seleccionarnpos[2]:=ncol;
    
end;

procedure captura(var mat:matriz;filaorigen,colorigen,filadestino,coldestino:integer);
var filaintermedia,colintermedia:integer;
begin
    filaintermedia:=(filaorigen+filadestino) div 2;
    colintermedia:=(colorigen+coldestino) div 2;
    
    
end;


function movvalido(mat:matriz;seleccionarpos:arrpos;seleccionarnpos:arrpos;color:char):boolean;
var filaorigen,filadestino,colorigen,coldestino,filadist,coldist,filainterm,colinterm:integer;

begin
    filaorigen:=seleccionarpos[1];
    colorigen:=seleccionarpos[2];
    filadestino:=seleccionarnpos[1];
    coldestino:=seleccionarnpos[2];
    
    filadist := abs(filadestino - filaorigen);
    coldist := abs(coldestino - colorigen);

    
    if (mat[filadestino,coldestino]='x') or (mat[filadestino,coldestino]='o') then begin
        writeln('la posicion de destino esta ocupada');
        movvalido:=false;
    end;
        
    if filadist<>coldist then
    begin
        writeln('el movimiento no es diagonal');
        movvalido:=false;
    end;
        
            //en caso que haya una ficha opuesta
    if filadist=2 then
        begin
            filainterm:=(filadestino+filaorigen) div 2;
            colinterm:=(coldestino+colorigen) div 2;
            //en caso que no haya ficha opuesta
            
            if mat[filainterm,colinterm]<>color then
                begin
                writeln('no hay ficha para capturar');
                movvalido:=false;
                exit;
                end;
        end;
    movvalido:=true;
end;

function seleccionvalida(mat:matriz;vpos:arrpos;color:char):boolean;
begin
    if mat[vpos[1],vpos[2]]=color then
    seleccionvalida:=true
    else
        seleccionvalida:=false;
end;


procedure mover(var mat:matriz;var vpos,npos:arrpos;color:char);
var vfila,vcol,nfila,ncol:integer;
begin
        
        vfila:=vpos[1];
        vcol:=vpos[2];
        nfila:=npos[1];
        ncol:=npos[2];

        mat[vfila,vcol]:=' ';
        mat[nfila,ncol]:=color;

end;


function cambiarturno(color:char):char;
begin
    if color=BLANCA then
        cambiarturno:=NEGRA
    else
        cambiarturno:=BLANCA;
end;

procedure juego(var mat:matriz);
var color:char;
    fila,columna:integer;
    nfila,ncol:integer;
    colopuesto:char;
    seleccion1,seleccion2,gameover:boolean;
    npos,vpos:arrpos;
begin
        
    color:=BLANCA;
    
    
    if color='x' then 
        colopuesto:='o'
    else
        colopuesto:='x';
    gameover:=perdio(color);
    
    
    while gameover=false do begin
        writeln('turno del jugador de las fichas:',color);

        seleccion1:=false;
        while seleccion1=false do begin
        
        vpos:=seleccionarpos(mat,color,fila,columna);
            if seleccionvalida(mat,vpos,color)=true then
            seleccion1:=true;
        end;
        
        seleccion2:=false;
        while seleccion2=false do begin
        
        npos:=seleccionarnpos(nfila,ncol);
        
        if movvalido(mat,vpos,npos,color)=true then begin
            mover(mat,vpos,npos,color);
            seleccion2:=true;
            end
        else
            writeln('movimiento invalido');
        end;
        
        
        cambiarturno(color);
        gameover:=perdio(color);
    end;
    
    if perdio(color)=true then
        writeln('el ganador es', colopuesto);

end;

begin
  InicMatriz(mat);
  CargarFichas(mat, BLANCA, CANT_FICHAS);
  CargarFichas(mat, NEGRA, CANT_FICHAS);
  DibujarMatriz(mat);
  
    juego(mat);  
  
end.
