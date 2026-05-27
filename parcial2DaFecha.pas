{Se desea automatizar el manejo de información referente al desempeño histórico de
los equipos de fútbol de la Liga Profesional Argentina. Para esto se cuenta con un
archivo maestro que contiene, por cada equipo, la siguiente información: código de
equipo, nombre del equipo, cantidad de partidos jugados, cantidad de partidos
ganados, cantidad de partidos empatados, cantidad de partidos perdidos y cantidad
de puntos acumulados. El archivo maestro está ordenado por código de equipo.
Al finalizar la temporada (año), se reciben 12 archivos detalle (uno por cada mes),
que contienen información de los partidos jugados por los equipos durante cada mes
del año. Cada archivo contiene múltiples registros con la siguiente información:
código de equipo, fecha del partido, cantidad de puntos obtenidos en ese partido (3
si ganó, 1 si empató, 0 si perdió) y código del equipo rival. Los archivos detalle están
ordenados por código de equipo. En cada archivo puede haber información de
cualquier equipo, y un mismo equipo puede aparecer más de una vez o no aparecer
en absoluto.
Defina los tipos de datos necesarios para representar la información del archivo
maestro y los archivos detalles, e implemente un procedimiento (y los
procedimientos que utilice) que permita actualizar el archivo maestro a partir de los
archivos detalle, recalculando los valores estadísticos de cada equipo: partidos
jugados, ganados, empatados, perdidos y puntos acumulados. Además, durante el
mismo recorrido en que se actualiza la información, se debe determinar e informar
por pantalla el equipo que más puntos sumó a lo largo de la temporada (año). Se
debe mostrar el nombre del equipo junto con la cantidad de puntos obtenidos en el
año.
Notas:
1. Los nombres de los archivos deben pedirse por teclado. Se puede suponer
que los nombres ingresados corresponden a archivos existentes.
2. Los archivos se deben recorrer una única vez.
Si un equipo A jugó un partido contra un equipo B, en un archivo detalle aparecerán dos registros
separados: uno para el equipo A, y otro para el equipo B. Los partidos se registran de forma
independiente para cada equipo.}
//corregido

program untitled;
const
	VA = 9999;//valor alto
	N = 12;//para los detalles
type
	str30=string[30];
	TEquipo=record //para maestro
		codEquipo:integer;
		nombreEquipo:str30;
		cantJ:integer;
		cantG:integer;
		cantE:integer;
		cantP:integer;
		cantPuntos:integer;
	end;
	
	TPartido=record //para detalle
		codEquipo:integer;
		fechaPartido:longInt;
		cantPuntos:integer;
		codRival:integer;
	end;
	
	maestro = file of TEquipo;
	detalle = file of TPartido;
	
	//por cada detalle hay un registro del detalle
	regDet = array[1..N]of TPartido;
	
	arrDet = array[1..N]of detalle; 

procedure leer(var a:detalle; var dato:TPartido);//acordarse leer el detalle(no el maestro) , ya que con este actualizamos el maestro
begin
	if(not(EOF(a)))then
		read(a,dato)
	else
		dato.codEquipo := VA;
end;



procedure minimo(var vDet:arrDet ; var rDet:regDet ; var min:TPartido);//buscamos el minimo asi no rompemos el orden del maestro
var
	i,posMin:integer;
begin
	posMin:=-1;min.codEquipo:=VA;
	for i:= 1 to N do begin
		if(rDet[i].codEquipo < min.codEquipo)then begin
			min:=rDet[i];
			posMin:=i;
		end;
	end;
	if(min.codEquipo <> VA)then
		leer(vDet[posMin],rDet[posMin]);
end;

procedure asignarArchivos(var m:maestro ; var vDet:arrDet);//Los nombres de los archivos deben pedirse por teclado.
var
	i:integer;
	nombreArchivo:str30;
begin
	writeln('Ingrese el nombre del archivo maestro: ');
	readln(nombreArchivo);
	assign(m,nombreArchivo);
	for i := 1 to N do begin
		writeln('Ingrese el nombre del archivo detalle: ', i);
		readln(nombreArchivo);
		assign(vDet[i],nombreArchivo);
	end;
end;

procedure ejercicio(var m:maestro ; var vDet: arrDet);
var
	i:integer; min:TPartido;
	puntos,maxPuntos:integer; nombreMax:str30;
	regM:TEquipo;
	partidos:regDet;
begin
	maxPuntos:=-1;
	asignarArchivos(m,vDet);
	reset(m);
	for i := 1 to N do begin
		reset(vDet[i]);
		leer(vDet[i],partidos[i]);//guardo el registro de los detalles en partidos
	end;
	minimo(vDet,partidos,min);//agarro el minimo
	while(min.codEquipo <> VA)do begin //los detalles estan ordenados por codigo equipo , me fijo que no sea EOF
		read(m,regM);//leo del maestro
		while(regM.codEquipo <> min.codEquipo)do //el maestro esta ordenado por codigo equipo , busco el equipo
			read(m,regM);
		puntos:=0;//empiezo a contar la cant de puntos del minimo
		while(regM.codEquipo = min.codEquipo)do begin // En cada archivo puede haber información de cualquier equipo, y un mismo equipo puede aparecer más de una vez o no aparecer
			puntos := puntos + min.cantPuntos;
			regM.cantJ := regM.cantJ +1;
			if(min.cantPuntos = 3)then
				regM.cantG:=regM.cantG + 1
			else 
				if(min.cantPuntos = 1)then
					regM.cantE:=regM.cantE + 1
				else
					regM.cantP:=regM.cantP + 1;
			minimo(vDet,partidos,min);//sigo leyendo de los detalles
		end;
		regM.cantPuntos:=regM.cantPuntos+puntos; // sumo los puntos
		if(puntos > maxPuntos)then begin //busco el equipo con mas puntos
			maxPuntos:=puntos;
			nombreMax:=regM.nombreEquipo;
		end;
		seek(m,filePos(m)-1);//muevo el puntero a la anterior posicion
		write(m,regM);//modifico el maestro
	end;
	writeln('El equipo que sumó más puntos durante la temporada fue: ', nombreMax, ' con ', maxPuntos, ' puntos.');
	close(m);//guardo las modificaciones del maestro
	for i := 1 to N do
		close(vDet[i]);//guardo las modificaciones de los detalles
end;

var
	m:maestro;
	vDet:arrDet;
BEGIN
	ejercicio(m,vDet);
END.

