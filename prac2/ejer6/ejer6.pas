program untitled;
uses crt;

const
valorAlto=9999;
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
regDet=array[1..n]of cDetalle;

procedure leer(var arc_detalle:detalle ; var dato:cDetalle);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.cod:=valorAlto;
end;


procedure leerMaestro(var arc_maestro:maestro ; var dato:cMaestro);
begin
	if not eof(arc_maestro)then
		read(arc_maestro,dato)
	else
		dato.cod:=valorAlto;
end;

procedure minimo(var registro:regDet ;var min:cDetalle ; var deta:arDet);
var
i,indiceMin:integer;
begin
	indiceMin:=0;
	min.cod:=valorAlto;
	for i:= 1 to n do
		if(registro[i].cod <> valorAlto)then
			if(registro[i].cod < min.cod)or((registro[i].cod = min.cod)and(registro[i].cepa < min.cepa))then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leer(deta[indiceMin],registro[indiceMin]);
	end;
end;

procedure actualizarMaestro(var arc_maestro:maestro);
var
deta:arDet;
registro:regDet;
min:cDetalle;
m:cMaestro;
i,codActual,cepaActual,totalFallecidos,totalRecuperados,activos,nuevos:integer;
aString:string;
begin
	rewrite(arc_maestro);
	for i:=1 to n do begin
		Str(i,aString);
		Assign(deta[i],'detalle'+aString);
		reset(deta[i]);
		leer(deta[i],registro[i]);
	end;
	minimo(registro,min,deta);
	while(min.cod <> valorAlto)do begin
		codActual:=min.cepa;
		while(min.cod = codActual)do begin
			cepaActual:=min.cepa;
			totalFallecidos:=0;
			totalRecuperados:=0;
			while(codActual = min.cod)and(cepaActual = min.cepa)do begin
				totalFallecidos+=min.cF;
				totalRecuperados+=min.cRec;
				activos:=min.cAc;
				nuevos:=min.cNue;
				minimo(registro,min,deta);
			end;
			read(arc_maestro,m);
			while(m.cod <> codActual)do
				read(arc_maestro,m);
			while(m.cepa <> cepaActual)do
				read(arc_maestro,m);
				
			m.cF+=totalFallecidos;
			m.cRec+=totalRecuperados;
			m.cAc:=activos;
			m.cNue:=nuevos;
			
			seek(arc_maestro,filePos(arc_maestro)-1);
			write(arc_maestro,m);
		end;
	end;
	for i:= 1 to n do 
		close(deta[i]);
	close(arc_maestro);
	end;
	
procedure recorrerMaestro(var arc_maestro:maestro);
var
p:cMaestro;
codActual,totalActivos:integer;
begin
	reset(arc_maestro);
	leerMaestro(arc_maestro,p);
	while(p.cod <> valorAlto)do begin
		codActual:=p.cod;
		totalActivos:=0;
		while(p.cod = codActual)do begin
			totalActivos:=totalActivos+ p.cAc;
			leerMaestro(arc_maestro,p);
		end;
		if(totalActivos > 50)then
			writeln('la localidad de: ',p.nombre,' tiene mas de 50 casos activos con un total de: ',totalActivos);
	end;
	close(arc_maestro);
end;

var
arc_maestro:maestro;
BEGIN
	Assign(arc_maestro,'maestro');
	actualizarMaestro(arc_maestro);
	recorrerMaestro(arc_maestro);
END.

