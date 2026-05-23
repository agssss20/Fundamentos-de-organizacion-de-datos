program ejer1;
const
	valorMax = 9999;
type
	empleado=record
		codigo:integer;
		nombre:string;
		montoC:real;
	end;
	compacto=record
		codigo:integer;
		montoC:real;
	end;
	
	detail = file of empleado;
	master = file of compacto;
	
procedure leer2(var archivo:detail;var dato:empleado);
begin
	if(not(eof(archivo)))then
		read(archivo,dato)
	else
		dato.codigo:=valorMax;
end;

procedure leer(var e:empleado);
begin
	with e do begin
		write('ingrese codigo de empleado:  ');readln(codigo);
		if(codigo <> -1)then begin
			write('ingrese nombre del empleado:  ');readln(nombre);
			write('ingrese monto de la comision:  ');readln(montoC);
		end;
		writeln('');
	end;
end;

procedure crear(var arc_log:detail);
var 
	e:empleado;
begin
	rewrite(arc_log);
	leer(e);
	while(e.codigo <> -1)do begin
		write(arc_log,e);
		leer(e);
	end;
	close(arc_log);
end;

procedure imprimirEmpleado(e:empleado);
begin
	writeln('codigo: ', e.codigo);
	writeln('nombre: ', e.nombre);
	writeln('monto: ', e.montoC:2:1);
end;

procedure imprimirCompacto(c:compacto);
begin
	writeln('codigo: ', c.codigo);
	writeln('monto Total por Codigo: ', c.montoC:2:1);
end;


//realizo el corte de control debido a que La información del archivo se encuentra ordenada por código de empleado 
//y cada empleado puede aparecer más de una vez en el archivo de comisiones.
procedure reciboYCompacto(var maestro:master ; var detalle:detail);
var
	e:empleado;
	c:compacto;
	codActual:integer;
begin
	rewrite(maestro);
	reset(detalle);
	leer2(detalle,e);
	while(e.codigo <> valorMax)do begin
		codActual:=e.codigo;
		c.montoC:=0;
		while(e.codigo = codActual)do begin
			c.montoC:=c.montoC + e.montoC;
			leer2(detalle,e);
		end;
		c.codigo:=codActual;//paso el codigo actual al compactado
		write(maestro,c);//escribo en detalle
	end;
	close(detalle);
	close(maestro);
end;

procedure mostrarDetalle(var detalle:detail);
var
	e:empleado;
begin
	reset(detalle);
	while not eof(detalle)do begin
		read(detalle,e);
		imprimirEmpleado(e);
	end;
	close(detalle);
end;

procedure mostrarMaestro(var maestro:master);
var 
	c:compacto;
begin
	reset(maestro);
	while not eof(maestro)do begin
		read(maestro,c);
		imprimirCompacto(c);
	end;
	close(maestro);
end;


var
	maestro:master;
	detalle:detail;
BEGIN
	Assign(maestro,'arc_emp');
	Assign(detalle,'arc_comp');
	crear(detalle);
	writeln('');
	mostrarDetalle(detalle);
	writeln('');
	reciboYCompacto(maestro,detalle);
	writeln('');
	mostrarMaestro(maestro);
END.

