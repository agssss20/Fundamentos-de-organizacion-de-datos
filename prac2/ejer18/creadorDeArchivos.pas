program untitled;

const
n=15;
type
cMaestro=record
	cod_localidad:integer;
	nom_localidad:string[25];
	cod_municipio:integer;
	nom_municipio:string[25];
	cod_hospital:integer;
	nom_hospital:string[25];
	fecha:string[8];
	cantCasos:integer;
end;

maestro= file of cMaestro;

procedure imprimirC1(c:cMaestro);
begin
	with c do begin
		writeln('codigo: ', cod_Localidad);
		writeln('nombre localidad', nom_localidad);
		writeln('cod municipio',cod_municipio);
		writeln('nombre municipio',nom_municipio);
		writeln('cod hospital',cod_hospital);
		writeln('nombre hospital',nom_hospital);
		writeln('ingrese fecha: ', fecha);
		writeln('ingrese cant casos: ', cantCasos);
		writeln('');
	end;
end;
procedure leerC1(var c:cMaestro);
begin
	with c do begin
		writeln('ingrese codigo: ');readln(cod_localidad);
		if(c.cod_localidad <> -1)then begin
			writeln('ingrese nombre localidad');readln(nom_localidad);
			writeln('ingrese cod municipio');readln(cod_municipio);
			writeln('ingrese nombre municipio');readln(nom_municipio);
			writeln('ingrese codigo hospital');readln(cod_hospital);
			writeln('ingrese nombre hospital');readln(nom_hospital);
			writeln('ingrese fecha');readln(fecha);
			writeln('ingrese cantCasos');readln(cantCasos);
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
	while(c.cod_localidad <> -1)do begin
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
		writeln('');
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

