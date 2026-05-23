{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}


program untitled;
const 
valorAlto = 9999;
type
ave = record 
	cod:integer;
	nom:string[50];
	fam:string[50];
	des:string[50];
	zona:string[50];
end;

archivo = file of ave;

procedure leer(var a:ave);
begin
	with a do begin
		writeln('ingrese cod: ');readln(cod);
		if(cod <> -1)then begin
			writeln('ingrese nom: ');readln(nom);
			writeln('ingrese fam: ');readln(fam);
			writeln('ingrese des: ');readln(des);
			writeln('ingrese zona: ');readln(zona);
		end;
		writeln('');
	end;
end;


procedure imprimir(a:ave);
begin
	with a do begin
		writeln('codigo ',cod,' nombre: ' , nom , ' familia: ',fam,' des: ',des,' zona: ',zona);
		writeln('');
	end;
end;

procedure leerArc(var arc_log:archivo;var dato:ave);
begin
	if not eof(arc_log)then
		read(arc_log,dato)
	else
		dato.cod:=valorAlto;
end;

procedure crear(var arc_log:archivo);
var
n:ave;
begin
	rewrite(arc_log);
	leer(n);
	while(n.cod <> -1)do begin
		write(arc_log,n);
		leer(n)
	end;
	close(arc_log);
end;

procedure mostrar(var arc_log:archivo);
var
n:ave;
begin
	reset(arc_log);
	leerArc(arc_log,n);
	while(n.cod <> valorAlto)do begin
		imprimir(n);
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;


procedure eliminarArc(var arc_log:archivo ; codigo:integer);//realizo las bajas logicas 
var
n:ave;
ok:boolean;
begin
	reset(arc_log);
	ok:=false;
	writeln('');
	leerArc(arc_log,n);
	while(n.cod <> valorAlto)and not(ok)do begin
		if(n.cod = codigo)then begin
			n.nom:='@Eliminado';
			seek(arc_log,filePos(arc_log)-1);
			write(arc_log,n);
			ok:=true;
		end
		else
			leerArc(arc_log,n);
	end;
	if(ok)then
		writeln('ave eliminada')
	else
		writeln('no se encontro ave');
	writeln('');
	close(arc_log);
end;


procedure compactar(var arc_log:archivo);//realizo las bajas fisicas teniendo en cuenta las bajas logicas
var
n:ave;
pos:integer;
begin
	reset(arc_log);
	leerArc(arc_log,n);
	while(n.cod <> valorAlto)do begin
		if(n.nom = '@Eliminado')then begin//encuentro la baja logica
			pos:= (filePos(arc_log)-1);//guardo la posicion de esa baja
			seek(arc_log,fileSize(arc_log)-1);//me paro en el ultimo registro de mi archivo
			read(arc_log,n);//lo leo y lo guardo en n
			while(n.nom = '@Eliminado')do begin//mientras siga teniendo/encontrando bajas logicas
				seek(arc_log,fileSize(arc_log)-1);//me paro en los registros marcados
				truncate(arc_log);//trunco para evitar repetidos
				seek(arc_log,fileSize(arc_log)-1);//me paro de vuelta en los registros marcados si hay
				read(arc_log,n);//sigo leyendo y sigo evaluando si hay mas registros marcados
			end;
			seek(arc_log,pos);//me paro en la posicion del registro marcado
			write(arc_log,n);//escribo el registro que guarde en n
			seek(arc_log,fileSize(arc_log)-1);//me paro en el ultimo registro del archivo
			truncate(arc_log);//trunco para evitar duplicados
			seek(arc_log,pos);//reubico de vuelta el puntero donde tengo el registro copiado para seguir leyendo el archivo y no dejar ningun registro sin leer
		end;
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;


procedure baja(var arc_log:archivo);
var
codigo:integer;
begin
	write('ingrese codigo del ave a eliminar: ');readln(codigo);
	while(codigo <> 5000)do begin//mientras no tenga el codigo 5000(me dice que el num 50000 se va de rango)sigo haciendo bajas logicas
		eliminarArc(arc_log,codigo);
		write('ingrese codigo del ave que desea eliminar: ');readln(codigo);
	end;
	compactar(arc_log);//realizo las bajas fisicas(lo compacto), no son lo mismo , compacto(recupero espacio), baja fisica(elimino los registros que ya no quiero en mi archivo)
end;


var
arc_log:archivo;

BEGIN
	Assign(arc_log,'archivo');
	//crear(arc_log);
	mostrar(arc_log);
	baja(arc_log);
	mostrar(arc_log);
END.

