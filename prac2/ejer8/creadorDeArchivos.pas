program untitled;
type

cliente=record
	cod:integer;
	NyA:string;//nombre y apellido
	anio:integer;
	mes:1..12;
	dia:1..31;
	montoV:real;
end;

maestro=file of cliente;

procedure imprimirC1(c:cliente);
begin
	with c do begin
		writeln('codigo: ', cod);
		writeln('nombre y apellido', NyA);
		writeln('anio',anio);
		writeln('mes',mes);
		writeln('dia',dia);
		writeln('monto',montoV:1:1);
		writeln('');
	end;
end;
procedure leerC1(var c:cliente);
begin
	with c do begin
		writeln('ingrese codigo: ');readln(cod);
		if(c.cod <> -1)then begin
			writeln('ingrese nombre y apellido');readln(NyA);
			writeln('ingrese anio');readln(anio);
			writeln('ingrese mes');readln(mes);
			writeln('ingrese dia');readln(dia);
			writeln('ingrese monto');readln(montoV);
		end;
		writeln('')
	end;
end;

procedure crearMaestro(var arc_maestro:maestro);
var
	c:cliente;
begin
	rewrite(arc_maestro);
	leerC1(c);
	while(c.cod <> -1)do begin
		write(arc_maestro,c);
		leerC1(c);
	end;
	close(arc_maestro);
end;

procedure mostrarMaestro(var arc_maestro:maestro);
var
c:cliente;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,c);
		imprimirC1(c);
	end;
	close(arc_maestro);
end;

var
arc_maestro:maestro;
BEGIN
	Assign(arc_maestro,'maestro');
	{crear(arc_maestro);}
	mostrarMaestro(arc_maestro);
END.

