{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program untitled;
const
valorAlto=9999;
type
asistente=record
	AyN:string[50];
	nro:integer;
	mail:string[50];
	telefono:string;
	dni:string[8]
end;

archivo = file of asistente;//archivo de tipo asistente

//leo mi archivo de asistentes hasta llegar a fin de archivo
procedure leerArc(var arc_log:archivo;var dato:asistente);
begin
	if not eof(arc_log)then
		read(arc_log,dato)
	else
		dato.nro:=valorAlto;
end; 


//leo mi asistente
procedure leer(var a :asistente);
begin
	with a do begin
		writeln('ingrese nro de asistente');readln(nro);
		if(nro <> -1)then begin
			writeln('ingrese apellido y nombre');readln(AyN);
			writeln('ingrese mail');readln(mail);
			writeln('ingrese telefono');readln(telefono);
			writeln('ingrese dni');readln(dni);
		end;
		writeln('');
	end;
end;


//imprimo mi registro de asistente
procedure imprimir(a:asistente);
begin
	with a do begin
		if(AyN <> '@Eliminado')then begin
			writeln('nro de asistente ', nro , ' mail ', mail , ' telefono ', telefono , ' dni ', dni);
			writeln('');
		end;
	end;
end;


//muestro mi archivo de asistentes
procedure mostrarArc(var arc_log:archivo);
var
a:asistente;
begin
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log,a);
		imprimir(a);
	end;
	close(arc_log);
end;

//creo mi archivo 
procedure crear(var arc_log:archivo);
var
a:asistente;
begin
	rewrite(arc_log);
	leer(a);
	while(a.nro <> -1)do begin
		write(arc_log,a);
		leer(a);
	end;
	close(arc_log);
end;

//elimino de forma logica mi registro de long fija
procedure eliminar(var arc_log:archivo);
var
a:asistente;
begin
	reset(arc_log);
	leerArc(arc_log,a);
	while(a.nro <> valorAlto)do begin
		if(a.nro < 1000)then begin //pregunto por numero de asistente  
			a.AyN := '@Eliminado';//si es menor a 1000 le asigno en AyN @Eliminado dando a entender que es informacion eliminada(de forma logica)
			seek(arc_log,filePos(arc_log)-1);//reubico el puntero ya que se movio a la siguiente posicion
			write(arc_log,a);//escribo en la posicion en donde quiero modificar mi registro que queria que se elimine
		end;
		leerArc(arc_log,a);//sigo leyendo registros para evitar un bucle infinito
	end;
end;

var
arc_log:archivo;
BEGIN
	Assign(arc_log,'archivo.dot');
	{crear(arc_log);}
	eliminar(arc_log);
	mostrarArc(arc_log);
END.

