program untitled;
const
valorAlto=9999;
type
cliente=record
	cod:integer;
	NyA:string;//nombre y apellido
	anio:integer;
	mes:1..12;
	dia:1..31;
	montoV:real;
end;

maestro = file of cliente;

procedure imprimirCliente(c:cliente);
begin
	with c do begin
		writeln('|codigo:',cod);
		writeln('|nombre y apelldio:',NyA);
	end;
end;

procedure leer(var arc_maestro:maestro; var dato:cliente);
begin
	if not eof(arc_maestro)then
		read(arc_maestro,dato)
	else
		dato.cod:=valorAlto;
end;

procedure reporte(var arc_maestro:maestro);
var
c:cliente;
totalMes,totalAnio,total:real;
codActual,anioActual,mesActual:integer;
begin
	reset(arc_maestro);
	leer(arc_maestro,c);
	total:=0;
	while(c.cod <> valorAlto)do begin
		imprimirCliente(c);
		codActual:=c.cod;
		while(c.cod = codActual)do begin
			writeln('anio: ',c.anio);
			anioActual:=c.anio;
			totalAnio:=0;
			while(c.cod = codActual)and(c.anio = anioActual)do begin
				writeln('mes: ',c.mes);
				mesActual:=c.mes;
				totalMes:=0;
				while(c.cod = codActual)and(c.anio = anioActual)and(c.mes=mesActual)do begin
					writeln('dia: ',c.dia);
					writeln('monto: ',c.montoV:1:1);
					totalMes:=totalMes+c.montoV;
					leer(arc_maestro,c);
				end;
				writeln('total mes: ',totalMes:1:1);
				totalAnio:=totalAnio + totalMes;
			end;
			writeln('total anio: ',totalAnio:1:1);
			total:=total + totalAnio;
		end;
	end;
	writeln('total empresa ',total:1:1);
	close(arc_maestro);
end;

var
arc_maestro:maestro;
BEGIN
	Assign(arc_maestro,'maestro');
	reporte(arc_maestro);
END.

