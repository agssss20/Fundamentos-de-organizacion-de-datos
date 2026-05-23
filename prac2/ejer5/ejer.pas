program ejer5;

uses crt;
const
valorAlto=9999;
n=3;
type
fallecido=record
	matricula:string;
	fecha:string;
	hora:string;
	lugar:string;
end;

dead=record
	nro:integer;
	dni:string[8];
	nombre:string;
	datos:fallecido;
end;

alive=record
	nro:integer;
	nombre:string;
	direccion:string;
	matricula:string;
	nombreM:string;
	dniM:string;
	nombreP:string;
	dniP:string;
end;

cMaestro=record
	datos:alive;
	seMurio:boolean;
	enEfecto:fallecido;
end;

maestro=file of cMaestro;

detalleVIVO= file of alive;
detalleMUERTO=file of dead;

arrayVIVO=array[1..n] of detalleVIVO;
arrayMUERTO=array[1..n] of detalleMUERTO;

arrayRV=array[1..n] of alive;
arrayRM=array[1..n] of dead;

procedure leerMUERTO(var arc_detalle:detalleMUERTO ; var dato:dead);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.nro:=valorAlto;
end;


procedure leerVIVO(var arc_detalle:detalleVIVO ; var dato:alive);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.nro:=valorAlto;
end;

procedure imprimirMas(m:cMaestro);
begin
	with m do begin
		writeln('nro: ',datos.nro,' |nombre ',datos.nombre,' |direccion ',datos.direccion,' |matricula medico ',datos.matricula);
		writeln('nombre madre ',datos.nombreM,' |dni madre ',datos.dniM,' |nombre padre ',datos.nombreP,' |dni padre ',datos.dniP);
		writeln('esta muerto? ', seMurio,' |matricula medico: ', enEfecto.matricula);
		writeln('fecha: ', enEfecto.fecha,' |hora de falleciemiento: ',enEfecto.hora,' |lugar de fallecimiento: ',enEfecto.lugar);
		writeln('');
	end;
end;

procedure mostrarMaestro(var arc_maestro:maestro);
var
	m:cMaestro;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,m);
		imprimirMas(m);
	end;
	close(arc_maestro);
end;

procedure minimoVIVO(var registro:arrayRV ;var min:alive ; var deta:arrayVIVO);
var
i,indiceMin:integer;
begin
	indiceMin:=0;
	min.nro:=valorAlto;
	for i:= 1 to n do
		if(registro[i].nro <> valorAlto)then
			if(registro[i].nro < min.nro)then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leerVIVO(deta[indiceMin],registro[indiceMin]);
	end;
end;


procedure minimoMUERTO(var registro:arrayRM ;var min:dead ; var deta:arrayMUERTO);
var
i,indiceMin:integer;
begin
	indiceMin:=0;
	min.nro:=valorAlto;
	for i:= 1 to n do
		if(registro[i].nro <> valorAlto)then
			if(registro[i].nro < min.nro)then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leerMUERTO(deta[indiceMin],registro[indiceMin]);
	end;
end;

procedure crearMaestro(var arc_maestro:maestro; var detaVIVO:arrayVIVO;var detaMUERTO:arrayMUERTO; var regVIVO:arrayRV; var regMUERTO:arrayRM);
var
minV:alive;
minM:dead;
m:cMaestro;
i:integer;
aString:string;
begin
	rewrite(arc_maestro);
	for i:=1 to n do begin
		Str(i,aString);
		Assign(detaVIVO[i],'detalleVIVO'+aString);
		reset(detaVIVO[i]);
		leerVIVO(detaVIVO[i],regVIVO[i]);
		Assign(detaMUERTO[i],'detalleMUERTO'+aString);
		reset(detaMUERTO[i]);
		leerMUERTO(detaMUERTO[i],regMUERTO[i]);
	end;
	minimoVIVO(regVIVO,minV,detaVIVO);
	minimoMUERTO(regMUERTO,minM,detaMUERTO);
	writeln(minV.nro,minM.nro);
	while(minV.nro <> valorAlto)do begin
		if(minV.nro = minM.nro)then begin
			m.seMurio:=true;
			m.enEfecto:=minM.datos;
			minimoMUERTO(regMUERTO,minM,detaMUERTO);
		end
		else begin
			m.seMurio:=false;
			m.enEfecto.matricula:='';
			m.enEfecto.fecha:='';
			m.enEfecto.hora:='';
			m.enEfecto.lugar:='';
		end;
		m.datos:=minV;
		write(arc_maestro,m);
		minimoVIVO(regVIVO,minV,detaVIVO);
	end;
	close(arc_maestro);
	for i:= 1 to n do begin
		close(detaVIVO[i]);
		close(detaMUERTO[i]);
	end;
end;


var
arc_maestro:maestro;
detaVIVO:arrayVIVO;
detaMUERTO:arrayMUERTO;
regVIVO:arrayRV;
regMUERTO:arrayRM;
BEGIN
	Assign(arc_maestro,'maestro');
	crearMaestro(arc_maestro,detaVIVO,detaMUERTO,regVIVO,regMUERTO);
	mostrarMaestro(arc_maestro);
END.

