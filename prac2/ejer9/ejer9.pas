program untitled;
const
valorAlto=9999;
type
cMaestro=record
	codP:integer;
	codL:integer;
	nro:integer;
	cantV:integer;
end;

maestro = file of cMaestro;

procedure leer(var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof(arc_maestro)then
		read(arc_maestro,dato)
	else
		dato.codP:=valorAlto;
end;

procedure listado(var arc_maestro:maestro);
var
m:cMaestro;
totalProvincia,totalLocalidad,total:integer;
provActual,locActual:integer;
begin
	reset(arc_maestro);
	leer(arc_maestro,m);
	total:=0;
	while(m.codP <> valorAlto)do begin
		provActual:=m.codP;
		totalProvincia:=0;
		writeln('|codigo provincia');
		writeln('',m.codp);
		writeln('|codigo localidad |total votos');
		while(m.codP = provActual)do begin
			locActual:=m.codL;
			totalLocalidad:=0;
			while(m.codP = provActual)and(m.codL = locActual)do begin
				totalLocalidad:=totalLocalidad + m.cantV;
				leer(arc_maestro,m);
			end;
			writeln('',locActual,'      ',totalLocalidad);
			totalProvincia:= totalProvincia + totalLocalidad;
		end;
		writeln('|total votos de provincia: ',totalProvincia);
		writeln('');
		writeln('');
		total+=totalProvincia
	end;
	writeln('--------------------------');
	writeln('total general de votos: ',total);
	close(arc_maestro);
end;

var
arc_maestro:maestro;
BEGIN
	Assign(arc_maestro,'maestro');
	listado(arc_maestro);
END.

