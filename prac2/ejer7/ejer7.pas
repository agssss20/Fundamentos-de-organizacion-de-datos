program untitled;
uses crt;
const
valorAlto=9999;
n=3;
type

cMaestro=record
	cod:integer;
	nombre:string;
	des:string;
	stockA:integer;
	stockM:integer;
	precio:real;
end;

cDetalle=record
	cod:integer;
	cantV:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array[1..n]of detalle;
regDet = array[1..n]of cDetalle;

procedure leer(var arc_Det:detalle ; var data:cDetalle);
begin
	if not eof(arc_Det)then
		read(arc_Det,data)
	else
		data.cod:=valorAlto;
end;

procedure minimo(var registro:regDet ;var min:cDetalle ; var arc_det:arDet);
var
	i,indiceMin:integer;
begin
	indiceMin:=0;
	min.cod:=valorAlto;
	for i:= 1 to n do
		if(registro[i].cod <> valorAlto)then
			if(registro[i].cod < min.cod)then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leer(arc_det[indiceMin],registro[indiceMin]);
	end;
end;

procedure actualizar(var arc_maestro:maestro);
var
registro:regDet;
min:cDetalle;
deta:arDet;
cantidadV,i,codActual:integer;
aString:string;
m:cMaestro;
begin
	reset(arc_maestro);
	for i := 1 to n do begin
		Str(i,aString);//genero string del detalle
		Assign(deta[i],' detalle ' + aString);
		reset(deta[i]);
		leer(deta[i],registro[i]);//leo el primer registro de los 30 archivos y lo escribo en el array de registros 
	end;
	minimo(registro,min,deta);//obtengo el minimo
	while(min.cod <> valorAlto)do begin
		codActual:=min.cod;
		cantidadV:=0;
		while(min.cod = codActual)do begin
			cantidadV:=cantidadV + min.cantV;
			minimo(registro,min,deta);
		end;
		read(arc_maestro,m);
		while(m.cod <> codActual)do begin
			read(arc_maestro,m);
		end;
		seek(arc_maestro,filePos(arc_maestro)-1);//busco el puntero y lo ubico
		m.stockA:=m.stockA - cantidadV;//actualizo el stock
		write(arc_maestro,m);//actualizo maestro
	end;
	close(arc_maestro);
	for i:=1 to n do
		close(deta[i]);
end;

procedure hacerTxt(var arc_maestro:maestro ; var arcTxt:Text);
var
	p:cMaestro;
begin
	reset(arc_maestro);
	rewrite(arcTxt);
	while not eof(arc_maestro)do begin
		read(arc_maestro,p);
		if(p.stockA < p.stockM)then
			with p do begin
				writeln(arcTxt,cod,' ',nombre,' ',des,' ',stockA,' ',stockM,' ',precio);
			end;
	end;
	close(arc_maestro);
	close(arcTxt);
end;

var
arc_maestro:maestro;
arcTxt: Text;

BEGIN
	Assign(arc_maestro,'maestro');
	Assign(arcTxt,'menosStock.txt');
	actualizar(arc_maestro);
	hacerTxt(arc_maestro,arcTxt);
END.

