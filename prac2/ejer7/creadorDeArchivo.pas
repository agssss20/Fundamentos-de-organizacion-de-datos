program untitled;
uses crt;
const 
n=2;
type
producto=record
	cod:integer;
	nombre:string;
	precio:real;
	stockA:integer;
	stockM:integer;
end;
suc=record
	cod:integer;
	cantidadVendida:integer;
end;

maestro=file of producto;
detalle=file of suc;
ar_detalle=array[1..n]of detalle;

procedure leerProducto(var p:producto);
begin
	with p do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese nombre: ');readln(nombre);
			write('ingrese stock disponible: ');readln(stockA);
			write('ingrese stock minimo: ');readln(stockM);
			write('ingrese precio: ');readln(precio);
		end;
		writeln('');
	end;
end;

procedure imprimirPr(p:producto);
begin
	with p do begin
		writeln('codigo: ', cod);
		writeln('nombre: ', nombre);
		writeln('stock disponible: ', stockA);
		writeln('stock minimo: ', stockM);
		writeln('precio: ', precio:1:1);
		writeln('');
	end;
end;

procedure leerDet(var d:suc);
begin
	with d do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese cantidad vendida: ');readln(cantidadVendida);
		end;
		writeln('');
	end;
end;


procedure imprimirDet(d:suc);
begin
	with d do begin
		writeln('codigo: ', cod);
		writeln('cantidad venidida: ', cantidadVendida);
		writeln('');
	end;
end;

procedure crearMaestro(var arc_maestro:maestro);
var
	p:producto;
begin
	rewrite(arc_maestro);
	leerProducto(p);
	while(p.cod <> -1)do begin
		write(arc_maestro,p);
		leerProducto(p);
	end;
	close(arc_maestro);
end;


procedure crearDetalle(var arc_detalle:detalle);
var
	d:suc;
begin
	rewrite(arc_detalle);
	leerDet(d);
	while(d.cod <> -1)do begin
		write(arc_detalle,d);
		leerDet(d);
	end;
	close(arc_detalle);
end;

procedure mostrarDetalle(var arc_detalle:detalle);
var
	d:suc;
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
	p:producto;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,p);
		imprimirPr(p);
	end;
	close(arc_maestro);
end;

var
arc_maestro:maestro;
aString:string;
i:integer;
deta:ar_detalle;
BEGIN
	Assign(arc_maestro,'maestro');
	{crearMaestro(arc_maestro);}
	mostrarMaestro(arc_maestro);
	for i:=1 to n do begin
		Str(i,aString);
		Assign(deta[i],'detalle' + aString);
		{crearDetalle(deta[i]);}
		mostrarDetalle(deta[i]);
	end;
	
END.

