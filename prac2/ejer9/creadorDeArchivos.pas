program untitled;
type

cMaestro=record
	codP:integer;
	codL:integer;
	nro:integer;
	cantV:integer;
end;

maestro = file of cMaestro;

procedure imprimirC1(c:cMaestro);
begin
	with c do begin
		writeln('codigo provincia: ', codP);
		writeln('codigo localidad', codL);
		writeln('numero mesa:',nro);
		writeln('cantidad votos: ', cantV);
		writeln('');
	end;
end;
procedure leerC1(var c:cMaestro);
begin
	with c do begin
		writeln('ingrese codigo porvincia: ');readln(codP);
		if(codP <> -1)then begin
			writeln('ingrese nombre y apellido');readln(codL);
			writeln('ingrese numero de mesa');readln(nro);
			writeln('ingrese cantidad de votos');readln(cantV);
		end;
		writeln('')
	end;
end;

procedure crearMaestro(var arc_maestro:maestro);
var
	c:cMaestro;
begin
	rewrite(arc_maestro);
	leerC1(c);
	while(c.codP <> -1)do begin
		write(arc_maestro,c);
		leerC1(c);
	end;
	close(arc_maestro);
end;

procedure mostrarMaestro(var arc_maestro:maestro);
var
c:cMaestro;
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

