program untitled;

const
valorAlto=9999;
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

procedure leer(var arc_maestro:maestro ; var dato:cMaestro);
begin
	if not eof(arc_maestro)then
		read(arc_maestro,dato)
	else
		dato.cod_localidad:=valorAlto;
end;

procedure pantalla(var arc_maestro:maestro; var arcTxt:Text);
var
m:cMaestro;
locActual,munActual,hosActual,total,locCasos,munCasos,hosCasos:integer;
nomHospital,nomLoc,nomMunicipio:string;
begin
	reset(arc_maestro);
	rewrite(arcTxt);
	leer(arc_maestro,m);
	total:=0;
	while(m.cod_localidad <> valorAlto)do begin
		writeln('nombre localidad', m.nom_localidad);
		locActual:=m.cod_localidad;
		locCasos:=0;
		while(m.cod_localidad = locActual)do begin
			writeln('nombre municipio', m.nom_municipio);
			munActual:=m.cod_municipio;
			munCasos:=0;
			nomLoc:=m.nom_localidad;
			while(m.cod_localidad = locActual)and(m.cod_municipio = munActual)do begin
				hosActual:=m.cod_hospital;
				hosCasos:=0;
				nomMunicipio:=m.nom_municipio;
				while(m.cod_localidad = locActual)and(m.cod_municipio = munActual)and(hosActual=m.cod_hospital)do begin
					hosCasos+=m.cantCasos;
					nomHospital:=m.nom_hospital;
					leer(arc_maestro,m);
				end;
				writeln('nombre hospital: ',nomHospital,'cant casos: ',hosCasos);
				munCasos+=hosCasos;
			end;
			if(munCasos > 1500)then begin
				writeln(arcTxt,munCasos,' ',nomMunicipio);
				writeln(arcTxt,nomLoc);
			end;
			writeln('cantidad casos municipio',munActual);
			writeln(' ',munCasos);
			locCasos+=munCasos;
		end;
		writeln('cantidad casos localidad',locActual);
		writeln(' ',locCasos);
		writeln('');
		total+=locCasos;
	end;
	writeln('cantidad casos totales en provincia');
	writeln(' ',total);
	writeln('');
	close(arc_maestro);
	close(arcTxt);
end;


var
arc_maestro:maestro;
arcTxt:Text;
BEGIN
	Assign(arc_maestro,'maestro');
	Assign(arcTxt,'exportar.txt');
	pantalla(arc_maestro,arcTxt);
END.

