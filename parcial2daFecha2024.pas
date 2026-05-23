{
  Se desea automatizar el manejo de información referente a los casos positivos de dengue para la
Provincia de Buenos Aires. Para esto se cuenta con un archivo maestro que contiene la siguiente
información: código de municipio, nombre municipio y cantidad de casos positivos. Dicho archivo está
ordenado por código de municipio.

Todos los meses se reciben 30 archivos que contienen la siguiente información: código de municipio
y cantidad de casos positivos. El orden de cada archivo detalle es por código de municipio. En cada
archivo puede venir información de cualquier municipio, y municipio puede aparecer cero o más de
una vez en cada archivo.

Realice el sistema completo que permita la actualización de la información del archivo maestro a
partir de los archivos detalle recalculando la cantidad de casos positivos e informando por pantalla
aquellos municipios (código y nombre) donde la cantidad total de casos positivos es mayor a 15.

Nota: cada archivo debe recorrerse una única vez.

Nota 1: Los nombres de los archivos deben pedirse por teclado. Se puede suponer que los
nombres ingresados corresponden a archivos existentes.

Nota 2: El informe debe incluir cualquier municipio que cumpla la condición,
independientemente de si se actualiza o no.
}


program untitled;
const 
	VA = 9999;
	N = 30;
type
	//reg maestro
	casos=record
		codMunicipio:integer;
		nomMunicipio:string;
		cantCasosPositivos:integer;
	end;
	
	//reg detalle
	casosDet=record
		codMunicipio:integer;
		cantCasosPositivos:integer;
	end;
	
	maestro= file of casos;//archivo maestro
	
	detalle = file of casosDet;//archivo detalle
	
	//por cada detalle hay un registro del detalle
	vectorDet = array [1..N] of detalle;
	regDet = array [1..N] of casosDet;
	
//acordarse leer el detalle(no el maestro) , ya que con este actualizamos el maestro
procedure leer(var a:detalle ; var c:casosDet);
begin
	if(not(EOF(a)))then
		read(a,c)
	else
		c.codMunicipio := VA;
end;

//buscamos el minimo asi no rompemos el orden del maestro
procedure minimo(var vDet:vectorDet ; var rDet:regDet ; var min:casosDet);
var
	i,posMin:integer;
begin
	posMin := -1;
	min.codMunicipio := VA;
	for i := 1 to N do begin
		if(rDet[i].codMunicipio < min.codMunicipio)then begin
			posMin:= i;
			min:=rDet[i];
		end;
	end;
	if(min.codMunicipio <> VA)then
		leer(vDet[posMin],rDet[posMin]);
end;

//Los nombres de los archivos deben pedirse por teclado. Se puede suponer que los
//nombres ingresados corresponden a archivos existentes.
procedure asignarArchivos(var m:maestro ; var vDet:vectorDet);
var
	i:integer;
	nombre:string[30];
begin
	writeln('Ingrese el nombre del archivo maestro: ');
	readln(nombre);
	assign(m,nombre);
	for i := 1 to N do begin
		writeln('Ingrese el nombre del archivo detalle: ');
		readln(nombre);
		assign(vDet[i],nombre);
	end;
end;

procedure modificarMaestro(var m:maestro ; var vDet:vectorDet);
var
	i:integer;
	regM:casos;
	casosTotales:integer;
	casosDetalle:regDet;
	min:casosDet;
begin
	asignarArchivos(m,vDet);
	reset(m);
	for i := 1 to N do begin
		reset(vDet[i]);
		leer(vDet[i],casosDetalle[i]);//guardo el registro de los detalles en casosDetalle
	end;
	minimo(vDet,casosDetalle,min);//agarro el minimo
	while(min.codMunicipio <> VA)do begin
		read(m,regM);
		while(regM.codMunicipio <> min.codMunicipio)do // el maestro esta ordenado por codigo de municipio
			read(m,regM);
		casosTotales:=0;
		while(regM.codMunicipio = min.codMunicipio)do begin //El orden de cada archivo detalle es por código de municipio. En cada archivo puede venir información de cualquier municipio, y municipio puede aparecer cero o más de una vez en cada archivo.
			casosTotales:= casosTotales + min.cantCasosPositivos;
			minimo(vDet,casosDetalle,min); //sigo leyendo de los detalles
		end;
		regM.cantCasosPositivos := regM.cantCasosPositivos + casosTotales;// sumo los casos
		if(regM.cantCasosPositivos > 15)then // recalcule los casos y pregunto si superan los 15 casos
			writeln('cod municipio: ',regM.codMunicipio,' nom municipio: ',regM.nomMunicipio);
		seek(m,filePos(m)-1);//muevo el puntero a la anterior posicion
		write(m,regM);//modifico el maestro
	end;
	close(m);//guardo las modificaciones del maestro
	for i := 1 to N do
		close(vDet[i]);//guardo las modificaciones de los detalles
end;




//ARBOLES punto a

const 
	M = 5 ;//orden del arbol
type
	cliente=record 
		num:integer;
	end;
	
	tNodo=record
		cant_claves:integer;
		claves: array [1..M-1] of longint;
		enlaces:array [1..M-1] of integer;
		hijos:array[1..M] of integer;
	end;
	
	tArchivoDatos = file of cliente;
	arbolB = file of tNodo;

var
	archivoDatos:tArchivoDatos;
	archivoIndice:arbolB;


BEGIN
END.

