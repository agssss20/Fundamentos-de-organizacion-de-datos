program untitled;
uses crt;

const
n=3;
type

cMaestro=record
	fecha:string;
	cod:integer;
	nombre:string;
	des:string;
	precio:real;
	totalE:integer;
	totalEVendidos:integer;
end;

cDetalle=record
	fecha:string;
	cod:integer;
	cantV:integer;
end;

maestro=file of cMaestro;
detalle=file of cDetalle;

arDet=array [1..n] of detalle;//vector de archivo detalle 

procedure leerMaestro(var c:cMaestro);
begin
	with c do begin
		write('ingrese fecha: ');readln(fecha);
		if(fecha <> ' ')then begin
			write('ingrese codigo sucursal: ');readln(cod);
			write('ingrese nombre sucursal: ');readln(nombre);
			write('ingrese precio: ');readln(precio);
			write('ingrese total ejemplares: ');readln(totalE);
			write('ingrese total ejemplares vendidos: ');readln(totalEVendidos);
		end;
		writeln('');
	end;
end;

procedure imprimirMaestro(c:cMaestro);
begin
	with c do begin
		writeln('fecha: ',fecha,' |codigo ',cod,' |nombre ',nombre,' |precio ',precio:2:2);
		writeln('total ejem ',totalE,' |total ejem vendidos ',totalEVendidos);
		writeln('');
	end;
end;

procedure leerDet(var c:cDetalle);
begin
	with c do begin
		write('ingrese fecha: ');readln(fecha);
		if(fecha <> ' ')then begin
			write('ingrese codigo sucursal: ');readln(cod);
			write('ingrese cantidad vendida: ');readln(cantV);
		end;
		writeln('');
	end;
end;


procedure imprimirDet(c:cDetalle);
begin
	with c do begin
		writeln('codigo: ', fecha);
		writeln('cod sucursal', cod);
		writeln('cantidad venidida: ', cantV);
		writeln('');
	end;
end;

procedure crearMaestro(var arc_maestro:maestro);
var
	p:cMaestro;
begin
	rewrite(arc_maestro);
	leerMaestro(p);
	while(p.fecha <> ' ')do begin
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
	leerDet(d);
	while(d.fecha <> ' ')do begin
		write(arc_detalle,d);
		leerDet(d);
	end;
	close(arc_detalle);
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

var
arc_maestro:maestro;
aString:string;
i:integer;
deta:arDet;
BEGIN
	Assign(arc_maestro,'maestro');
	writeln('maestro: ');
	{crearMaestro(arc_maestro);}
	mostrarMaestro(arc_maestro);
	for i:=1 to n do begin
		Str(i,aString);
		Assign(deta[i],'detalle' + aString);
		{crearDetalle(deta[i]);}
		mostrarDetalle(deta[i]);
	end;
	
END.

