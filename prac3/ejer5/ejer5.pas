{5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}
program untitled;

const
valorAlto=9999;
type
reg_flor = record
nombre:String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;

procedure leerArc(var arc_log:tArchFlores ; var dato:reg_flor);
begin
	if not eof(arc_log)then
		read(arc_log,dato)
	else
		dato.codigo:=valorAlto;
end;

procedure leer(var n:reg_flor);
begin
	with n do begin
		write('ingrese codigo: ');readln(codigo);
		if(codigo <> -1)then begin
			write('ingrese nombre: ');readln(nombre);
		end;
		writeln('');
	end;
end;

procedure crear(var arc_log:tArchFlores);
var
n:reg_flor;
begin
	rewrite(arc_log);//creo el archivo de flores
	n.codigo:=0;//hago mi registro de cabecera con 0
	n.nombre:='Cabecera';
	write(arc_log,n);//escribo la info en el archivo
	leer(n);//leo el siguiente registro
	while(n.codigo <> -1)do begin
		write(arc_log,n);//sigo creando registros en el archivo
		leer(n);
	end;
	close(arc_log);
end;


procedure agregarFlor(var a:tArchFlores ; nombre:string ; codigo:integer);
var
indice:reg_flor;
n:reg_flor;
begin
	reset(a);//hablo el archivo de flores
	leerArc(a,n);//leo el registro de cabecera
	if(n.codigo < 0)then begin
		seek(a,abs(n.codigo));//voy a la posicion con espacio libre(uso abs para eso)
		read(a,indice);//leo el registro del indice
		seek(a,filePos(a)-1);//reubico el puntero
		n.nombre:=nombre;//modifico el registro
		n.codigo:=codigo;
		write(a,n);//escribo en el registro que queria modificar
		seek(a,0);//vuelvo al inicio del archivo
		write(a,indice);//lo declaro ahora como indice el archivo que borre
		writeln('flor agregada con exito');
	end
	else
		writeln('no hay espacio libre');
	close(a);
end;

procedure eliminarFlor(var arc_log:tArchFlores;flor:reg_flor);
var
n,indice:reg_flor;
ok:boolean;
begin
	reset(arc_log);
	ok:=false;
	leerArc(arc_log,indice);//leo el registro de cabecera
	leerArc(arc_log,n);
	while(n.codigo <> valorAlto)and not(ok)do begin
		if(n.codigo = flor.codigo)then begin
			ok:=true;
			n.codigo:=indice.codigo;//copio el indice que staba en el reg 0 en el que elimino para tener la lista invertida
			seek(arc_log,filePos(arc_log)-1);
			indice.codigo:=filePos(arc_log)*-1;//paso el indice a negativo
			write(arc_log,n);
			seek(arc_log,0);
			write(arc_log,indice);//el indice que esta en el registro cabecera lo reemplazo con el del reg que acabo de eliminar
		end
		else
			leerArc(arc_log,n);
	end;
	if(ok)then
		writeln('flor eliminada')
	else
		writeln('no se encontro flor');
	close(arc_log);
end;

procedure imprimir(n:reg_flor);
begin
	with n do begin
		if(codigo > 0)then begin
			writeln('|codigo: ',codigo,' nombre: ',nombre);
			writeln('');
		end;
	end;
end;

procedure mostrarPantalla(var arc_log:tArchFlores);
var
n:reg_flor;
begin
	reset(arc_log);
	seek(arc_log,1);
	leerArc(arc_log,n);
	while(n.codigo <> valorAlto)do begin
		imprimir(n);
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;




var
arc_log:tArchFlores;
r:reg_flor;
{nombre:string[45];}
codigo:integer;
BEGIN
	Assign(arc_log,'archiv.dot');
	{writeln('crear');
	crear(arc_log);
	writeln('');}
	writeln('eliminar');
	write('ingrese codigo: ');readln(codigo);
	writeln('');
	r.codigo:=codigo;
	eliminarFlor(arc_log,r);
	writeln('');
	{writeln('agregar');
	write('ingrese codigo: ');readln(codigo);
	write('ingrese nombre: ');readln(nombre);
	writeln('');
	agregarFlor(arc_log,nombre,codigo);
	writeln('');}
	writeln('listar en pantalla');
	mostrarPantalla(arc_log);
END.

