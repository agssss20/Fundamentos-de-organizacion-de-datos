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
	write('ingrese nom del archivo: ');readln(nombre);
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

procedure aniadirEmpleado(var arc_log:archivo);
var
	e:emp;
begin
	seek(arc_log,fileSize(arc_log));//uso el tamaño del archivo para recorrer la estructura(para eso sirve seek)
	leer(e);
	while(e.apellido <> 'fin')do begin
		write(arc_log,e);
		leer(e);
	end;
	close(arc_log);
end;

procedure modificar(var arc_log:archivo;nro:integer);
var
	e:emp;
	edad:integer;
	ok:boolean;
begin
	ok:=false;
	while not eof(arc_log)and not(ok)do begin
		read(arc_log,e);
		if(e.numE = nro)then begin
			ok:=true;
			write('ingrese la edad actualizada: ');readln(edad);
			e.edad:=edad;
			seek(arc_log,filepos(arc_log)-1);//uso la posicion y le resto 1 para no dejar datos afuera el registro(para eso sirve seek)
			write(arc_log,e);
		end;
	end;
	if(ok=false)then 
		writeln('no se encontro el num de empleado')
	else
		writeln('se modifico con exito');
	writeln('');
	close(arc_log);
end;

procedure eliminar(var arc_log:archivo ; nro:integer);
var
e:emp;
ok:boolean;
f:emp;//hago un registro a parte para guardar el que voy a modificar
begin
	ok:=false;
	seek(arc_log,FileSize(arc_log)-1);//agarro mi ultimo registro
	read(arc_log,f);//lo leo
	seek(arc_log,0);//me ubico devuelta al principio de mi archivo
	while not eof(arc_log)and not(ok) do begin//recorro todo el archivo hasta encontrar el numero de empleado indicado
		read(arc_log,e);//leo los registros
		if(e.numE = nro)then begin//encuentro el numero donde quiero realizar la baja
			ok:=true;//corto while
			seek(arc_log,filepos(arc_log)-1);//me reubico en el lugar donde voy a modificar el registro
			write(arc_log,f);//escribo mi registro del ultimo lugar guardado en f(por eso hice 2 registros del mismo tipo)
			seek(arc_log,FileSize(arc_log)-1);//actualizo el tamaño de mi archivo para dsp truncar
			truncate(arc_log);//trunco para evitar registros duplicados
		end;
	end;
	if(ok=false)then
		writeln('no se encontro el numero de empleado')
	else
		writeln('se elimino con exito');
	writeln('');
	close(arc_log);
end;

procedure exportarArchivo(var arc_log:archivo;var todos_emp:Text);
var
	e:emp;
begin
	reset(arc_log);
	rewrite(todos_emp);//creo el archivo de tipo texto
	while not eof(arc_log)do begin// paso del archivo de empleados a archivo de texto
		read(arc_log,e);
		with e do writeln(todos_emp,'|nro: ',numE:10,'|edad: ',edad:10,'|dni: ',dni:10,'|apellido: ',apellido:10,'|nombre: ',nom:10);
	end;
	close(arc_log);
	close(todos_emp);
end;

procedure dni00(var arc_log:archivo; var sin_dni:Text);
var
	e:emp;
begin
	reset(arc_log);
	rewrite(sin_dni);//creo el archivo de tipo texto
	while not eof(arc_log)do begin
		read(arc_log,e);
		if(e.dni = '00')then
			with e do writeln(sin_dni,'|nro: ',numE:10,'|edad: ',edad:10,'|dni: ',dni:10,'|apellido: ',apellido:10,'|nom: ',nom);
	end;
	close(arc_log);
	close(sin_dni);
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



procedure menu(var arc_log:archivo;var todos_emp,sin_dni:Text;nombre:string);
var
	opcion:integer;
	nro:integer;
begin
	writeln('ingrese por teclado que opcion desea realizar con el archivo: ', nombre);
	writeln('');
	writeln('1) crear archivo');
	writeln('');
	writeln('2) abrir archivo');
	writeln('');
	writeln('3) aniadir empleado');
	writeln('');
	writeln('4) modificar edad');
	writeln('');
	writeln('5) exportar a "todos_empleados.txt"');
	writeln('');
	writeln('6) exportar sin dni "faltaDNIEmpleado.txt"');
	writeln('');
	writeln('7) eliminar empelado"');
	writeln('');
	writeln('8) salir');
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
		3:
		begin
			reset(arc_log);
			aniadirEmpleado(arc_log);
		end;
		4:
		begin
			write('ingrese num de empleado para modificar la edad(-1 para finalizar)');
			readln(nro);
			while(nro<>-1)do begin
				reset(arc_log);
				modificar(arc_log,nro);
				write('ingrese num de empleado para modificar la edad(-1 para finalizar)');
				readln(nro);
			end;
		end;
		5:
		begin
			exportarArchivo(arc_log,todos_emp);
		end;
		6:
		begin
			dni00(arc_log,sin_dni);
		end;
		7:begin
		  write('ingrese nro de empleado a eliminar ');readln(nro);
		  while(nro <> -1)do begin
			reset(arc_log);
			eliminar(arc_log,nro);
			write('ingrese nro de empleado a eliminar ');readln(nro);
			end;
		  end;
		  8:halt;
		else writeln('no se encuentra la opcion');
	end;
end;
	
	
	
//PP
var
	nombre:string;
	arc_log:archivo;
	letra:char;
	loop:boolean;
	todos_emp,sin_dni:Text;
BEGIN
	loop:=true;
	textcolor(red);
	clrscr;
	ingresarNombre(nombre);
	Assign(arc_log,nombre);
	Assign(todos_emp,'todos_empleados.txt');
	Assign(sin_dni,'faltaDNIEmpleado.txt');
	menu(arc_log,todos_emp,sin_dni,nombre);
	while(loop)do begin
		write('ingrese cualquier caracter para ir al menu , ingrese E para cerrar consola');readln(letra);
		if(letra='E')or(letra='e')then
			loop:=false
		else begin
			clrscr;
			menu(arc_log,todos_emp,sin_dni,nombre);
		end;
	end;
END.

