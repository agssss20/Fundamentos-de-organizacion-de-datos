program CreadorDeArchivos;
uses crt;
const
n=3;
type
cMaestro=record
	cod:integer;
	nombre:string;
	cepa:integer;
	nombreC:string;
	cAc:integer;
	cNue:integer;
	cRec:integer;
	cF:integer;
end;


cDetalle=record
	cod:integer;
	cepa:integer;
	cAc:integer;
	cNue:integer;
	cRec:integer;
	cF:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet=array[1..n]of detalle;


procedure leerMaestro(var c:cMaestro);
begin
	with c do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese nombre municipio: ');readln(nombre);
			write('ingrese codigo cepa: ');readln(cepa);
			write('ingrese nombre cepa: ');readln(nombreC);
			write('ingrese casos activos: ');readln(cAc);
			write('ingrese casos nuevos: ');readln(cNue);
			write('ingrese casos recuperados: ');readln(cRec);
			write('ingrese casos fallecidos: ');readln(cF);
		end;
		writeln('');
	end;
end;

procedure imprimirMaestro(c:cMaestro);
begin
	with c do begin
		writeln('codigo municipio: ',cod,' |nombre municipio ',nombre,' |codigo cepa ',cepa,' |nombre cepa ',nombreC);
		writeln('casos activos ',cAc,' |casos nuevos ',cNue,' |recuperados ',cRec,' |casos fallecidos ',cF);
		writeln('');
	end;
end;


procedure leerDetalle(var c:cDetalle);
begin
	with c do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese codigo cepa: ');readln(cepa);
			write('ingrese casos activos: ');readln(cAc);
			write('ingrese casos nuevos: ');readln(cNue);
			write('ingrese casos recuperados: ');readln(cRec);
			write('ingrese casos fallecidos: ');readln(cF);
		end;
		writeln('');
	end;
end;

procedure imprimirDet(c:cDetalle);
begin
	with c do begin
		writeln('codigo municipio: ',cod,' |codigo cepa ',cepa);
		writeln('casos activos ',cAc,' |casos nuevos ',cNue,' |recuperados ',cRec,' |casos fallecidos ',cF);
		writeln('');
	end;
end;

procedure crearMaestro(var arc_maestro:maestro);
var
p:cMaestro;
begin
	rewrite(arc_maestro);
	leerMaestro(p);
	while(p.cod <> -1)do begin
		write(arc_maestro,p);
		leerMaestro(p);
	end;
	close(arc_maestro);
end;

procedure crearDetalle(var arc_detalle:detalle);
var
d:cDetalle;
begin
	rewrite(arc_detalle);
	leerDetalle(d);
	while(d.cod <> -1)do begin
		write(arc_detalle,d);
		leerDetalle(d);
	end;
	close(arc_detalle);
end;

procedure mostrarMaestro(var arc_maestro:maestro);
var
p:cMaestro;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,p);
		imprimirMaestro(p);
	end;
	close(arc_maestro);
end;

procedure mostrarDetalle(var arc_detalle:detalle);
var
d:cDetalle;
begin
	reset(arc_detalle);
	while not eof(arc_detalle)do begin
		read(arc_detalle,d);
		imprimirDet(d);
	end;
	close(arc_detalle);
end;

var
	arc_maestro:maestro;
	aString:string;
	i:integer;
	deta:arDet;
BEGIN
	Assign(arc_maestro,'maestro');
	writeln('maestro: ');
	crearMaestro(arc_maestro);
	mostrarMaestro(arc_maestro);
	for i := 1 to n do begin
		writeln('detalle: ',i,' : ');
		Str(i,aString);
		Assign(deta[i],'detalle'+ aString);
		crearDetalle(deta[i]);
		mostrarDetalle(deta[i]);
	end;
END.

