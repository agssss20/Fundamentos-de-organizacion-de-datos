{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}
program untitled;

uses crt;
const 
valorAlto = 9999;
type
novela = record
	cod:integer;
	gen:string[10];
	nom:string[50];
	dur:string[10];
	dir:string[50];
	precio:real;
end;

archivo = file of novela;

procedure leerArc(var arc_log:archivo ; var dato :novela);
begin
	if not eof(arc_log)then
		read(arc_log,dato)
	else
		dato.cod := valorAlto;
end;

procedure ingresarNombre(var nombre:string);
begin
	write('ingrese nombre del archivo: ');readln(nombre);
	writeln('');
end;

procedure leer(var n:novela);
begin
	with n do begin
		write('ingrese cod');readln(cod);
		if(cod <> -1)then begin
			write('ingrese genero: ');readln(gen);
			write('ingrese nombre: ');readln(nom);
			write('ingrese duracion: ');readln(dur);
			write('ingrese director: ');readln(dir);
			write('ingrese precio: ');readln(precio);
		end;
	end;
	writeln('');
end;


procedure imprimir(n:novela);
begin
	with n do begin
		writeln('|codigo: ' , cod, ' |genero: ',gen, ' |nombre: ',nom, ' |duracion: ',dur, ' |direccion: ', dir, ' |precio: ', precio:0:2);
		writeln('');
	end;
end;


procedure crear(var arc_log:archivo);
var
n:novela;
begin
	rewrite(arc_log);
	n.cod:=0;
	write(arc_log,n);
	leer(n);
	while(n.cod <> -1)do begin
		write(arc_log,n);
		leer(n);
	end;
	close(arc_log);
end;

procedure mostrarPantalla(var arc_log:archivo);
var
n:novela;
begin
	seek(arc_log,1);//me paro en la segunda posicion del archivo , ya que el primero es 0(estamos en una lista , la cual marca como comienzo del archivo)
	leerArc(arc_log,n);
	while(n.cod <> valorAlto)do begin
		imprimir(n);
		leerArc(arc_log,n);
	end;
end;


procedure alta(var arc_log:archivo);
var
n:novela;
indice:novela;
begin
	leerArc(arc_log,n);
	if(n.cod < 0)then begin
		seek(arc_log,abs(n.cod));//voy a la posicion con espacio libre(uso abs para esp)
		read(arc_log,indice);//leo el registro que esta en esa posicion y me lo guardo en indice
		seek(arc_log,filePos(arc_log)-1);//reubico el puntero
		leer(n);//leo el registro
		write(arc_log,n);//escribo en la posicion donde habia espacio libre
		seek(arc_log,0);//vuelvo a registro de cabecera
		write(arc_log,indice);//escribo el indice que tenia almacenado en la posicion que acabo de dar de alta
	end
	else begin
		seek(arc_log,fileSize(arc_log));//sigo escribiendo en el archivo
		leer(n);
		write(arc_log,n);
	end;
end;

procedure modificarNovela(var n:novela);
var
opcion:integer;
begin
	writeln('ingrese por teclado que opcion desea realizar con el archivo: ');
	writeln('');
	writeln('1) precio');
	writeln('');
	writeln('2) genero');
	writeln('');
	writeln('3) nombre');
	writeln('');
	writeln('4) director');
	writeln('');
	writeln('5) duracion"');
	writeln('');
	write('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of
		1:
		begin
			write('ingrese nuevo precio: ');readln(n.precio);
		end;
		2:
		begin
			write('ingrese nuevo genero: ');readln(n.gen);
		end;
		3:
		begin
			write('ingrese nuevo nombre: ');readln(n.nom);
		end;
		4:
		begin
			write('ingrese nuevo director: ');readln(n.dir);
		end;
		5:
		begin
			write('ingrese nueva duracion: ');readln(n.dur);
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
	ok:=false;
	write('ingrese codigo de novela que desea modificar: ');readln(codigo);
	writeln('');
	leerArc(arc_log,n);
	while(n.cod <> valorAlto)and not (ok)do begin
		leerArc(arc_log,n);
		if(codigo = n.cod)then begin
			ok:=true;
			modificarNovela(n);
			seek(arc_log,FilePos(arc_log)-1);
			write(arc_log,n);
		end;
	end;
	if(ok)then
		writeln('novela modificada con exito')
	else
		writeln('no se encontro la novela');
end;

procedure eliminar(var arc_log:archivo);
var
n,indice:novela;
codigo:integer;
ok:boolean;
begin
	ok:=false;
	write('ingrese codigo de la novela que desea eliminar: ');readln(codigo);
	writeln('');
	leerArc(arc_log,indice);//leo el indice que esta en la cabecera
	leerArc(arc_log,n);
	while (n.cod <>  valorAlto)and not(ok)do begin
		if(n.cod = codigo)then begin
			ok:=true;
			n.cod:=indice.cod;//copio el indice que estaba en el reg 0 en el que elimino para tener la lista invertida
			seek(arc_log,filePos(arc_log)-1);//reubico el puntero
			indice.cod:=filePos(arc_log)*-1;//paso el indice a negativo
			write(arc_log,n);//lo escribo 
			seek(arc_log,0);//me reubico en el comienzo del archivo
			write(arc_log,indice);//el indice que esta en el registro cabecera lo reemplazo con el reg que acabo de eliminar 
		end
		else
			leerArc(arc_log,n);
	end;
	if(ok) then
		writeln('novela eliminada')
	else
		writeln('no se encontro la novela');
end;

procedure abrir(var arc_log:archivo);
var
opcion:integer;
begin
	reset(arc_log);
	writeln('ingrese por teclado que opcion desea realizar con el archivo: ');
	writeln('');
	writeln('1) mostrar en pantalla');
	writeln('');
	writeln('2) dar en alta novela');
	writeln('');
	writeln('3) modificar novela');
	writeln('');
	writeln('4) eliminar novela');
	writeln('');
	write('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of 
		1:mostrarPantalla(arc_log);
		2:alta(arc_log);
		3:modificar(arc_log);
		4:eliminar(arc_log);
	else
		writeln('no es una opcion valida');
	end;
	close(arc_log);
end;

procedure listar(var arc_log:archivo;var arcTxt:Text);
var
n:novela;
begin
	reset(arc_log);
	rewrite(arcTxt);
	seek(arc_log,1);//me salteo el de cabecera
	leerArc(arc_log,n);
	while(n.cod<>valorAlto)do begin
		with n do begin
			if(cod > 0)then
				writeln(arcTxt,'codigo: ',cod,' nombre: ',nom,' genero: ',gen,' director ',dir,' duracion ',dur,' precio: ',precio:1:1)
			else
				writeln(arcTxt,'espacio libre');
		end;
		leerArc(arc_log,n);
	end;
	close(arc_log);
	close(arcTxt);
end;

procedure menu(var arc_log:archivo ; var arcTxt:Text;nombre:string);
var
opcion:integer;
begin
	writeln('ingrese por teclado que opcion desea realizar con el archivo: ', nombre);
	writeln('');
	writeln('1) crear archivo');
	writeln('');
	writeln('2) abrir archivo');
	writeln('');
	writeln('3) listar');
	writeln('');
	writeln('4) salir en archivo de texto');
	writeln('');
	write('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of
	1:crear(arc_log);
	2:abrir(arc_log);
	3:listar(arc_log,arcTxt);
	4:halt;
	else
		writeln('no es una opcion');
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
		write('aprete cualquier tecla para menu. letra e para salir');readln(letra);
		if(letra = 'e')or (letra = 'E')then
			loop:=false
		else begin
			clrscr;
			menu(arc_log,arcTxt,nombre);
		end;
	end;
END.

