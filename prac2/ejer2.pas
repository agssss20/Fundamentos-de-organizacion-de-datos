program ejer2;
const 
	valorAlto=9999;
type
	rango=0..1;
	alumno=record
		cod:integer;
		apellido:string;
		nombre:string;
		cantMsin:integer;//sin final
		cantMcon:integer;//con final
	end;
	
	materia=record
		cod:integer;
		fin:rango;//0 desaprobado , 1 aprobado
		curs:rango;//0 desaprobado ,  1 aprobado
	end;
	
	maestro = file of alumno;
	detalle=file of materia;


//leo materias
procedure leer(var arc_detalle:detalle ; var dato:materia);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.cod:=valorAlto;
end;


//leo alumno
procedure leerAl(var a:alumno);
begin
	with a do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese apellido: ');readln(apellido);
			write('ingrese nombre: ');readln(nombre);
			write('ingrese cantidad de materias sin final: ');readln(cantMsin);
			write('ingrese cantidad de materias con final: ');readln(cantMcon);
		end;
		writeln('');
	end;
end;


//imprimo alumno
procedure imprimirAl(a:alumno);
begin
	with a do begin
		writeln('codigo: ', cod);
		writeln('apellido: ', apellido);
		writeln('nombre: ', nombre);
		writeln('sin final: ', cantMsin);
		writeln('con final: ', cantMcon);
	end;
end;

//leo detalle (materia)
procedure leerDet(var d:materia);
begin
	with d do begin
		write('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			write('ingrese si aprobo cursada: ');readln(curs);
			write('ingrese si aprobo final: ');readln(fin);
		end;
		writeln('');
	end;
end;


procedure imprimirDet(d:materia);
begin
	with d do begin
		writeln('codigo: ', cod);
		writeln('cursada: ', curs);
		writeln('final: ', fin);
	end;
end;


procedure crearMaestro(var arc_maestro:maestro);
var
	a:alumno;
begin
	rewrite(arc_maestro);
	leerAl(a);
	while(a.cod <> -1)do begin
		write(arc_maestro,a);
		leerAl(a);
	end;
	close(arc_maestro);
end;


procedure crearDetalle(var arc_detalle:detalle);
var
	d:materia;
begin
	rewrite(arc_detalle);
	leerDet(d);
	while(d.cod <> -1)do begin
		write(arc_detalle,d);
		leerDet(d);
	end;
	close(arc_detalle);
end;


procedure actualizar(var arc_maestro:maestro ; var arc_detalle:detalle);
var
	m:materia;a:alumno;aux:integer;
	//cantC:cursada - cantM:materia
	cantC,cantM:integer;
begin
	reset(arc_maestro);
	reset(arc_detalle);
	leer(arc_detalle,m);
	while(m.cod <> valorAlto)do begin
		aux:=m.cod;cantC:=0;cantM:=0;
		while(m.cod = aux)do begin
			if(m.curs <> 0)then
				cantC +=1;
			if(m.fin <> 0)then
				cantM += 1;
			leer(arc_detalle,m);
		end;
		read(arc_maestro,a);
		while(a.cod <> aux)do
			read(arc_maestro,a);
		a.cantMsin += cantC;
		a.cantMcon += cantM;
		seek(arc_maestro,filePos(arc_maestro)-1);
		write(arc_maestro,a);
	end;
	close(arc_maestro);
	close(arc_detalle);
end;

procedure mostrarDetalle(var arc_detalle:detalle);
var
	d:materia;
begin
	reset(arc_detalle);
	while not eof(arc_detalle)do begin
		read(arc_detalle,d);
		imprimirDet(d);
	end;
	close(arc_detalle);
end;


procedure mostrarMaestro(var arc_maestro:maestro);
var
	a:alumno;
begin
	reset(arc_maestro);
	while not eof(arc_maestro)do begin
		read(arc_maestro,a);
		imprimirAl(a);
	end;
	close(arc_maestro);
end;

procedure pasarTxt(var arc_maestro:maestro; var arcTxt:Text);
var
	a:alumno;
begin
	reset(arc_maestro);
	rewrite(arcTxt);
	while not eof(arc_maestro)do begin
		read(arc_maestro,a);
		if(a.cantMsin - a.cantMcon > 4)then
			with a do begin
				writeln(arcTxt,cod,' ',apellido,' ',nombre,' ',cantMsin,' ',cantMcon);
			end;
	end;
	close(arc_maestro);
	close(arcTxt);
end;

var
	arc_maestro:maestro;
	arc_detalle:detalle;
	arcTxt:Text;
BEGIN
	Assign(arc_maestro,'maestro');
	Assign(arc_detalle,'detalle');
	Assign(arcTxt,'alumnos.txt');
	crearMaestro(arc_maestro);
	writeln('');
	crearDetalle(arc_detalle);
	writeln('');
	mostrarMaestro(arc_maestro);
	writeln('');
	mostrarDetalle(arc_detalle);
	actualizar(arc_maestro,arc_detalle);
	writeln('');
	mostrarMaestro(arc_maestro);
	pasarTxt(arc_maestro,arcTxt);
END.

