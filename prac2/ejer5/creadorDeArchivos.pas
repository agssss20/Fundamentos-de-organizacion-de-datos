program untitled;
uses crt;
const
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

detalleVIVO= file of alive;
detalleMUERTO=file of dead;

arrayVIVO=array[1..n] of detalleVIVO;
arrayMUERTO=array[1..n] of detalleMUERTO;


procedure leerMUERTO(var m:dead);
begin
	with m do begin
		write('ingrese nro: ');readln(nro);
		if(nro <> -1)then begin
			write('ingrese dni: ');readln(dni);
			write('ingrese nombre: ');readln(nombre);
			write('ingrese matricula medico: ');readln(datos.matricula);
			write('ingrese fecha: ');readln(datos.fecha);
			write('ingrese hora: ');readln(datos.hora);
			write('ingrese lugar: ');readln(datos.lugar);
		end;
		writeln('');
	end;
end;


procedure leerVIVO(var m:alive);
begin
	with m do begin
		write('ingrese nro: ');readln(nro);
		if(nro <> -1)then begin
			write('ingrese direccion: ');readln(direccion);
			write('ingrese nombre: ');readln(nombre);
			write('ingrese matricula medico: ');readln(matricula);
			write('ingrese nombre madre: ');readln(nombreM);
			write('ingrese dni madre: ');readln(dniM);
			write('ingrese nombre padre: ');readln(nombreP);
			write('ingrese dni padre: ');readln(dniP);
		end;
		writeln('');
	end;
end;

procedure crearDetalleVIVO(var arc_detalle:detalleVIVO);
var
	d:alive;
begin
	rewrite(arc_detalle);
	leerVIVO(d);
	while(d.nro <> -1)do begin
		write(arc_detalle,d);
		leerVIVO(d);
	end;
	close(arc_detalle);
end;

procedure crearDetalleMUERTO(var arc_detalle:detalleMUERTO);
var
	d:dead;
begin
	rewrite(arc_detalle);
	leerMUERTO(d);
	while(d.nro <> -1)do begin
		write(arc_detalle,d);
		leerMUERTO(d);
	end;
	close(arc_detalle);
end;


procedure imprimirDetVIVO(d:alive);
begin
	with d do begin
		writeln('nro: ',nro,' |nombre ',nombre,' |direccion ',direccion,' |matricula medico ',matricula);
		writeln('nombre madre ',nombreM,' |dni madre ',dniM,' |nombre padre ',nombreP,' |dni padre ',dniP);
		writeln('');
	end;
end;

procedure imprimirDetMUERTO(d:dead);
begin
	with d do begin
		writeln('nro: ',nro,' |nombre ',nombre,' |dni ',dni,' |matricula medico ',datos.matricula);
		writeln('fecha ',datos.fecha,' |hora ',datos.hora,' |lugar ',datos.lugar);
		writeln('');
	end;
end;

procedure mostrarDetalleVIVO(var arc_detalle:detalleVIVO);
var
	d:alive;
begin
	reset(arc_detalle);
	while not eof(arc_detalle)do begin
		read(arc_detalle,d);
		imprimirDetVIVO(d);
	end;
	close(arc_detalle);
end;

procedure mostrarDetalleMUERTO(var arc_detalle:detalleMUERTO);
var
	d:dead;
begin
	reset(arc_detalle);
	while not eof(arc_detalle)do begin
		read(arc_detalle,d);
		imprimirDetMUERTO(d);
	end;
	close(arc_detalle);
end;

var
	aString:string;
	i:integer;
	detaVIVO:arrayVIVO;
	detaMUERTO:arrayMUERTO;
BEGIN
	writeln('acta de nacimiento');
	writeln('');
	for i:=1 to n do begin
		Str(i,aString);
		Assign(detaVIVO[i],'detalleVIVO'+ aString);
		{crearDetalleVIVO(detaVIVO[i]);}
		mostrarDetalleVIVO(detaVIVO[i]);
	end;
	writeln('acta de fallecimiento');
	writeln('');
	for i:=1 to n do begin
		Str(i,aString);
		Assign(detaMUERTO[i],'detalleMUERTO'+ aString);
		{crearDetalleMUERTO(detaMUERTO[i]);}
		mostrarDetalleMUERTO(detaMUERTO[i]);
	end;
END.

