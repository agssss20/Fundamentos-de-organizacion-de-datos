program untitled;
const
valorAlto = 'ZZZZ';
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

arDet=array[1..n]of detalle;
regDet=array[1..n]of cDetalle;

procedure leer(var arc_detalle:detalle ; var dato:cDetalle);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.fecha:=valorAlto;
end;

procedure minimo(var deta:arDet ;var min:cDetalle ; var registro:regDet);
var
	i,indiceMin:integer;
begin
	indiceMin:=0;
	min.fecha:=valorAlto;
	for i:= 1 to n do
		if(registro[i].fecha <> valorAlto)then
			if((registro[i].fecha < min.fecha)or((registro[i].fecha=min.fecha)and(registro[i].cod < min.cod)))then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leer(deta[indiceMin],registro[indiceMin]);
	end;
end;

procedure actualizar(var arc_maestro:maestro);
var
deta:arDet;
m:cMaestro;
registro:regDet;
i,cantidadVentas,codActual:integer;
aString,fechaActual:string;
min:cDetalle;
begin
	reset(arc_maestro);
	for i:=1 to n do begin
		Str(i,aString);//concateno los string usando la libreria crt con Str y ayudandome de aString
		Assign(deta[i],'detalle' + aString);
		reset(deta[i]);
		leer(deta[i],registro[i]);
	end;
	minimo(deta,min,registro);
	while(min.fecha <> valorAlto)do begin
		fechaActual:=min.fecha;
		while(min.fecha = fechaActual)do begin
			codActual:=min.cod;
			cantidadVentas:=0;
			while(min.fecha = fechaActual)and(min.cod = codActual)do begin
				cantidadVentas+=min.cantV;
				minimo(deta,min,registro);
			end;
			read(arc_maestro,m);
			while((m.fecha <> fechaActual)or(m.cod<>codActual))do begin
				read(arc_maestro,m);
			end;
			m.totalE-=cantidadVentas;
			m.totalEVendidos+=cantidadVentas;
			seek(arc_maestro,filePos(arc_maestro)-1);
			write(arc_maestro,m);
		end;
	end;
	for i:=1 to n do begin
		close(deta[i]);
	end;
	close(arc_maestro);
end;

var
arc_maestro:maestro;
m:cMaestro;
min,max:cMaestro;
BEGIN
	min.totalEVendidos:=9999;
	max.totalEVendidos:=-1;
	Assign(arc_maestro,'maestro');
	actualizar(arc_maestro);
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,m);
		if(m.totalEVendidos < min.totalEVendidos)then
			min:=m;
		if(m.totalEVendidos > max.totalEVendidos)then
			max:=m;
	end;
	close(arc_maestro);
	writeln('minimo: ',min.fecha,'',min.cod);
	writeln('maximo: ',max.fecha,'',max.cod);
END.

