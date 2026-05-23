program ejer4;
uses crt;
const
	valorAlto=9999;
	n=2;
type
	date=record
		dia:integer;
		mes:integer;
		anio:integer
	end;
	rec=record
		cod:integer;
		fecha:date;
		tiempo:real;
	end;
	maestro=file of rec;
	detalle=file of rec;
	arDet=array [1..n] of detalle;
	arRec=array[1..n] of rec;
	
procedure leer(var arc:detalle ; var d:rec);
begin
	if not eof(arc)then
		read(arc,d)
	else
		d.cod:=valorAlto;
end;

procedure minimo(var arc:arDet ;var registro:arRec ; var min:rec);
var
	i,indiceMin:integer;
begin
	indiceMin:=0;
	min.cod:=valorAlto;
	for i:= 1 to n do
		if(registro[i].cod <> valorAlto)then
			if(registro[i].cod < min.cod) or ((registro[i].cod = min.cod)and(registro[i].fecha.dia < min.fecha.dia)and(registro[i].fecha.mes < min.fecha.mes)and(registro[i].fecha.anio < min.fecha.anio))then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leer(arc[indiceMin],registro[indiceMin]);
	end;
end;

procedure actualizar(var arcM:maestro ; var det:arDet);
var
	min:rec;i:integer;registro:arRec;actual:rec;
begin
	reset(arcM);
	for i := 1 to n do begin
		reset(det[i]);
		leer(det[i],registro[i]); 
	end;
	minimo(det,registro,min);//obtengo el minimo
	while(min.cod <> valorAlto)do begin
		actual.cod:=min.cod;;
		while(min.cod = actual.cod)do begin
			actual.fecha:=min.fecha;
			actual.tiempo:=0;
		end;
		while(min.cod = actual.cod)and((min.fecha.dia = actual.fecha.dia)and(min.fecha.mes = actual.fecha.mes)and(min.fecha.anio = actual.fecha.anio))do begin
			actual.tiempo += min.tiempo;
			minimo(det,registro,min);
		end;
		write(arcM,actual);
	end;
	for i:=1 to n do
		close(det[i]);
	close(arcM);
end;


procedure imprimirMas(m:rec);
begin
	with m do begin
		writeln('codigo: ', cod);
		writeln('fecha: ', fecha.dia,'/',fecha.mes,'/',fecha.anio);
		writeln('tiempo total de sesion abiertas: ', tiempo:0:2);
		writeln('');
	end;
end;

procedure mostrarMaestro(var arc_maestro:maestro);
var
	m:rec;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,m);
		imprimirMas(m);
	end;
	close(arc_maestro);
end;

var
	arcM:maestro;
	det:arDet;
	i:integer;
	numero:string;
BEGIN
	Assign(arcM,'maestro');
	for i := 1 to n do begin
		Str(i,numero);
		Assign(det[i],'detalle ' + numero);
	end;
	actualizar(arcM,det);
	mostrarMaestro(arcM)
END.

