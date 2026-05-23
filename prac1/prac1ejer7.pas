program untitled;

uses crt;
type
	novela=record
		codigo:integer;
		precio:real;
		genero:string;
		nombre:string;
	end;

archivo=file of novela;

procedure ingresarNombre(var nombre:string);
begin
	write('ingrese nombre del archivo: ');readln(nombre);
	writeln('');
end;

procedure leer(var n:novela);
begin
	with n do begin
		write('ingrese codigo: ');readln(codigo);
		write('ingrese precio: ');readln(precio);
		write('ingrese genero: ');readln(genero);
		write('ingrese nombre: ');readln(nombre);
	end;
	write('');
end;

procedure imprimir(n:novela);
begin
	with n do begin
		writeln('|codigo: ', codigo);
		writeln('|precio: ', precio);
		writeln('|genero: ', genero);
		writeln('|nombre: ', nombre);
		writeln('');
	end;
end;

procedure crear(var arc_log:archivo;var arcTxt:Text);
var
	n:novela;
begin
	rewrite(arc_log);
	reset(arcTxt);
	while not eof(arc_log)do begin
		with n do begin
			readln(arcTxt,codigo,precio,genero);
			readln(arcTxt,nombre);
		end;
		write(arc_log,n);
	end;
	close(arc_log);
	close(arcTxt);
end;

procedure agregar(var arc_log:archivo);
var
	n:novela;
begin
	reset(arc_log);
	writeln('-agregar novela-');
	seek(arc_log,FileSize(arc_log));
	leer(n);
	write(arc_log,n);
	close(arc_log);
end;

procedure mostrarPantalla(var arc_log:archivo);
var
	n:novela;
begin
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log,n);
		imprimir(n);
	end;
	close(arc_log);
end;


procedure modificarNovela(var n:novela);
var
	opcion:integer;
begin
	writeln('seleccione que desea modificar: ');
	writeln('');
	writeln('1)precio');
	writeln('');
	writeln('2)genero');
	writeln('');
	writeln('3)nombre');
	writeln('');
	writeln('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of
	1:
		begin
			write('ingrese nuevo precio: ');readln(n.precio);
		end;
	2:
		begin
			write('ingrese nuevo genero');readln(n.genero);
		end;
	3:
		begin
			write('ingrese nuevo nombre');readln(n.nombre);
		end;
	else 
		writeln('no es una opcion valida');
	end;
	writeln('');
end;


procedure modificar(var arc_log:archivo);
var
	codigo:integer;
	ok:boolean;
	n:novela;
begin
	reset(arc_log);
	ok:=false;
	write('ingrese codigo de la novela que desea modificar: ');readln(codigo);
	writeln('');
	while not eof(arc_log)and not(ok) do begin
		read(arc_log,n);
		if(codigo=n.codigo)then begin
			ok:=true;
			modificarNovela(n);
			seek(arc_log,FilePos(arc_log)-1);
			write(arc_log,n);
		end;
	end;
	if(ok)then
		writeln('novela modificada');
	else
		writeln('no se encontro la novela');
	close(arc_log);
end;

procedure menu(var arc_log:archivo;var arcTxt:Text;nombre:string);
var
	opcion:integer;
begin
	writeln('ingrese opcion a realizar con el archivo: ' , nombre);
	writeln('');
	writeln('1)crear archivo binario');
	writeln('');
	writeln('2)mostrar en pantalla');
	writeln('');
	writeln('3)aniadir novela');
	writeln('');
	writeln('4)modificar novela');
	writeln('');
	writeln('5)salir');
	writeln('');
	writeln('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of
	1: crear(arc_log,arcTxt);
	2: mostrarPantalla(arc_log);
	3: agregar(arc_log);
	4: modificar(arc_log);
	5: halt
	else 
		writeln('no es una opcion correcta');
	end;
end;

var
	arc_log:archivo;
	arcTxt:Text;
	nombre:string;
	loop:boolean;
	letra:char;
BEGIN
	textcolor(red);
	loop:=true;
	ingresarNombre(nombre);
	Assign(arc_log,nombre);
	Assign(arcTxt,'novelas.txt');
	menu(arc_log,arcTxt,nombre);
	while(loop)do begin
		writeln('');
		write('ingrese cualquier caracter para abrir el menu , ingrese e para cerrar consola: ');readln(letra);
		if(letra = 'E')or(letra='e')then
			loop:=false
		else begin
			clrscr;
			menu(arc_log,arcTxt,nombre);
		end;
	end;
END.

