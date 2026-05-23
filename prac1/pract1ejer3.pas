program untitled;
uses crt;
type
	emp=record
		numE:integer;
		apellido:string[50];
		nom:string[50];
		edad:integer;
		dni:string;//el dni lleva puntos
	end;
	
	archivo=file of emp;
	
	
procedure ingresarNombre(var nombre:string);
begin
	write('ingrese nom del archiv: ');
	readln(nombre);
	writeln('');
end;

procedure leer(var e:emp);
begin
	with e do begin
		write('ingrese apellido: ');readln(apellido);
		if(apellido <> 'fin')then begin
			write('ingrese nombre: ');readln(nom);
			write('ingrese numero: ');readln(numE);
			write('ingrese edad: ');readln(edad);
			write('ingrese dni: ');readln(dni);
		end;
		writeln('');
	end;
end;

procedure imprimir(e:emp);
begin
	with e do begin
		writeln('nro: ',numE);
		writeln('apellido: ',apellido);
		writeln('nombre: ',nom);
		writeln('edad: ',edad);
		writeln('dni: ',dni);
		writeln('');
	end;
end;

procedure crear(var arc_log:archivo;nombre:string);
var
	e:emp;
begin
	rewrite(arc_log);//creo el archivo con rewrite
	leer(e);
	while(e.apellido<>'fin')do begin
		write(arc_log,e);
		leer(e);
	end;
	close(arc_log);//uso close para que los cambios se vean reflejados en el archivo
end;

procedure mostrarPantallaNomDeterminado(var arc_log:archivo);
var
	nom:string[50];
	e:emp;
begin
	write('ingrese nom o ape determinado: ');
	readln(nom);
	while not eof(arc_log)do begin
		read(arc_log,e);
		if(e.apellido = nom)or(e.nom=nom)then begin
			imprimir(e);
		end;
	end;
	close(arc_log);
end;

procedure mostrarDeAUno(var arc_log:archivo);
var
	e:emp;
begin
	while not eof(arc_log)do begin
		read(arc_log,e);
		imprimir(e);
	end;
	close(arc_log);
end;

procedure mostrarMayores(var arc_log:archivo);
var
	e:emp;
begin
	while not eof(arc_log)do begin
		read(arc_log,e);
		if(e.edad > 70)then begin
			imprimir(e);
		end;
	end;
	close(arc_log);
end;


procedure seleccion2(var arc_log:archivo);
var
	opcion:char;
begin
	writeln('ingrese la opcion que desea realizar con el archivo abierto(con minuscula)');
	writeln('');
	writeln('a.Listar en pantalla los datos de empleados que tengan un nom o ape determinados');
	writeln('b.Listar en pantalla los empleados de a uno por linea');
	writeln('c.listar en pantalla empleados mayores a 70 anios,proximos  a jubilarse ');
	writeln('');
	write('opcion elegidad --> ');
	readln(opcion);
	writeln('');
	case opcion of
		'a':mostrarPantallaNomDeterminado(arc_log);
		'b':mostrarDeAUno(arc_log);
		'c':mostrarMayores(arc_log);
		else writeln('no se encuentra la opcion');
	end;
end;



procedure menu(var arc_log:archivo;nombre:string);
var
	opcion:integer;
begin
	writeln('ingrese por teclado que opcion desea realizar con el archivo: ', nombre);
	writeln('');
	writeln('1) crear archivo');
	writeln('');
	writeln('2) abrir archivo');
	writeln('');
	write('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of
		1:
		begin
			crear(arc_log,nombre);
		end;
		2:
		begin
			reset(arc_log);
			seleccion2(arc_log);
		end;
		else writeln('no se encuentra la opcion');
	end;
end;
	
	
	
//PP
var
	nombre:string;
	arc_log:archivo;
	letra:char;
	loop:boolean;
BEGIN
	loop:=true;
	textcolor(red);
	clrscr;
	ingresarNombre(nombre);
	Assign(arc_log,nombre);
	menu(arc_log,nombre);
	while(loop)do begin
		write('ingrese cualquier caracter para ir al menu , ingrese E para cerrar consola');
		readln(letra);
		if(letra='E')or(letra='e')then
			loop:=false 
		else begin
			clrscr;
			menu(arc_log,nombre);
		end;
	end;
END.

