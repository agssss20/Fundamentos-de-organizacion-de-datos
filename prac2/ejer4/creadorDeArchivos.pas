program creadorDeArchivos;
uses crt;
const
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
	ar_detalle=array [1..n] of detalle;

procedure leer(var r:rec);
begin
	with r do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese dia: ');readln(fecha.dia);
			write('ingrese mes: ');readln(fecha.mes);
			write('ingrese anio: ');readln(fecha.anio);
			write('ingrese tiempo de sesion: ');readln(tiempo);
		end;
		writeln('');
	end;
end;



procedure imprimir(r:rec);
begin
	with r do begin
		writeln('codigo: ', cod);
		writeln('fecha: ', fecha.dia,'/',fecha.mes,'/',fecha.anio);
		writeln('tiempo total de sesion abiertas: ', tiempo:0:2);
	end;
end;

procedure crearDetalle(var arc_detalle:detalle);
var
	d:rec;
begin
	rewrite(arc_detalle);
	leer(d);
	while(d.cod <> -1)do begin
		write(arc_detalle,d);
		leer(d);
	end;
	close(arc_detalle);
end;

procedure mostrarDetalle(var arc_detalle:detalle);
var
	d:rec;
begin
	reset(arc_detalle);
	while not eof(arc_detalle)do begin
		read(arc_detalle,d);
		imprimir(d);
	end;
	close(arc_detalle);
end;

var
	arc_maestro:maestro;
	aString:string;
	i:integer;
	deta:ar_detalle;
BEGIN
	Assign(arc_maestro,'maestro');
	for i:=1 to n do begin
		Str(i,aString);
		Assign(deta[i],'detalle ' + aString);
		crearDetalle(deta[i]);
		mostrarDetalle(deta[i]);
	end;
END.

