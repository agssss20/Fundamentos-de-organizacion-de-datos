{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}



program untitled;
const 
valorAlto = 'ZZZ';
type
linux=record
	nom:string[50];
	anio:string[10];
	num:string[5];
	cant:integer;
	des:string[50];
end;

archivo = file of linux;

procedure leerArc(var arc_log:archivo ; var dato:linux);
begin
	if not eof(arc_log)then
		read(arc_log,dato)
	else
		dato.nom := valorAlto;
end;

procedure leer(var n:linux);
begin
	with n do begin
		write('ingrese nombre: ');readln(nom);
		if(nom <> ' ')then begin
			write('ingrese anio: ');readln(anio);
			write('ingrese num de version: ');readln(num);
			write('ingrese cant de desarrolladores: ');readln(cant);
			write('ingrese descripcion: ');readln(des);
		end;
	end;
	writeln('');
end;


procedure imprimir(n:linux);
begin
	with n do begin
		writeln(' nombre: ' , nom ,' anio: ',anio,' num de version: ',num , ' cant desarrolladores: ',cant,' descripcion: ',des);
		writeln('');
	end;
end;

procedure crear(var arc_log:archivo);
var
n:linux;
begin
	rewrite(arc_log);
	n.cant:=0;//creo mi registro de cabecera(estamos realizando una lista invertida)
	write(arc_log,n);//creo el registro de cabecera
	leer(n);
	while(n.nom <> ' ')do begin//sigo creando mas registros en el archivo
		write(arc_log,n);
		leer(n);
	end;
	close(arc_log);
end;

procedure mostrarPantalla(var arc_log:archivo);
var
n:linux;
begin
	reset(arc_log);
	seek(arc_log,1);//salteo el registro de cabecera de la lista invertida
	leerArc(arc_log,n);
	while(n.nom <> valorAlto)do begin
		imprimir(n);
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;


function ExisteDistribucion(nom:string ; var arc_log:archivo):boolean;
var
n:linux;
ok:boolean;
begin
	reset(arc_log);
	leerArc(arc_log,n);
	ok:=false;
	while(n.nom <> valorAlto)and not(ok)do begin
		if(n.nom = nom)then 
			ok:=true;
		leerArc(arc_log,n);
	end;
	close(arc_log);
	ExisteDistribucion:=ok;
end;


procedure AltaDistribucion(var arc_log:archivo);
var
n,indice,r:linux;
begin
	leer(r);//leo el registro que quiero dar de alta
	if not(ExisteDistribucion(r.nom,arc_log))then begin//si no existe ya ese registro lo doy de alta
		reset(arc_log);
		leerArc(arc_log,n);//leo el registro de cabecera para saber si tengo espacion disponible
		if(n.cant < 0)then begin//si la cant de usuarios es negativa doy el alta
			seek(arc_log,abs(n.cant));//voy a la posicion con espacio libre con absolute
			read(arc_log,indice);//leo el registro que esta en esa posicion y me lo guardo en la var indice
			seek(arc_log,filePos(arc_log)-1);//reubico el puntero
			write(arc_log,r);//escribo en la posicion donde habia espacio libre
			seek(arc_log,0);//vuelvo al registro cabecero
			write(arc_log,indice);//escribo en indice que tenia almacenado en la posicion que acabo de dar de alta , me va a indicar la sig posicion a la que debo ir o si ya no tengo espacio
		end
		else
			writeln('no hay espacio libre');
		close(arc_log);
	end
	else
		writeln('ya existe distribucion');
end;

procedure BajaDistribucion(var arc_log:archivo);
var
n,indice:linux;
nom:string[50];
ok:boolean;
begin
	ok:=false;
	write('ingrese nombre de la distribucion que desea eliminar: ');readln(nom);
	writeln('');
	if(ExisteDistribucion(nom,arc_log))then begin// me fijo si existe esa distribucion
		reset(arc_log);
		leerArc(arc_log,indice);//salteo mi primera posicion(debido a que estamos en lista invertida)
		leerArc(arc_log,n);//leo el registro que quiero eliminar
		while(n.nom <> valorAlto)and not(ok)do begin
			if(n.nom = nom)then begin
				ok:=true;
				n.cant:=indice.cant;//copio el indice que estaba en el registro 0 en el que elimino para tener la lista invertida
				seek(arc_log,filePos(arc_log)-1);//reubico el puntero
				indice.cant:=filePos(arc_log) *-1;//paso el indice (la posicion del archivo, que la dejo en cant. desarrolladores) a negativo
				write(arc_log,n);//escribo en la pos actual el indice que tenia anteriormente 
				seek(arc_log,0);//me paro al principio del archivo
				write(arc_log,indice);//el indice que esta en el registro cabecera lo reemplazo con el del reg que acabo de eliminar , me indicara luego a donde tengo espacio libre
			end
			else
				leerArc(arc_log,n);
		end;
		close(arc_log);
		writeln('distribucion eliminada');
	end
	else
		writeln('distribucion no existente');
end;

var
arc_log:archivo;
BEGIN
	Assign(arc_log,'archivo.dot');
	writeln('crear');
	crear(arc_log);
	mostrarPantalla(arc_log);
	writeln('baja');
	writeln('');
	BajaDistribucion(arc_log);
	writeln();
	writeln('alta');
	writeln('');
	AltaDistribucion(arc_log);
	writeln('');
	mostrarPantalla(arc_log);
END.

