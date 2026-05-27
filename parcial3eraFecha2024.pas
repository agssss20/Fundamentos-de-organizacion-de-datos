//corregido
program untitled;
type
	empleado=record
		numero:integer;
		nombre:string;
		apellido:string;
		dni:integer;
		fechaN:string;
		genero:string;
	end;
	
	tArchivo = file of empleado;
	
function existeEmpleado(var a:tArchivo  ; num:integer ):integer;
var
	pos:integer;
	e:empleado;
begin
	pos:=0;
	reset(a);
	read(a,e);//leo el de cabecera
	while(not(EOF(a))and(num <> e.numero))do begin
		read(a,e);
		if(num = e.numero)then
			pos:=(filePos(a)-1);
	end;
	close(a);
	existeEmpleado:=pos;
end; 

procedure altaEmpleado(var a:tArchivo);
var
	cabecera:empleado;
	e:empleado;
begin
	writeln('ingrese datos del empleado a agregar: ');//leo el empleado a desear de dar de alta
	readln(e.numero,e.nombre,e.apellido);
	readln(e.dni,e.fechaN,e.genero);
	if(existeEmpleado(a,e.numero) = 0)then begin //si es 0 es porque no existe
		reset(a);
		read(a,cabecera); //uso mi registro cabecera con mi lista invertida para poner el registro a dar de alta en el lugar deseado
		if(cabecera.numero = 0 )then begin
			seek(a,fileSize(a));
			write(a,e);//lo pongo al final si el registro de cabecera me indica que no hubo registros dados de baja
		end
		else begin//si hubo un registro borrado
			seek(a,cabecera.numero*-1); // me paro en ese lugar usando el codigo del cabecera pasandolo de negativo a positivo
			read(a,cabecera);//leo el de cabecera
			seek(a,filePos(a)-1);//me reubico el puntero
			write(a,e);//escribo el registro a dar de alta
			seek(a,0);//me paro al principio de archivo
			write(a,cabecera);//actualizo el registro cabecera
		end;
		close(a);
	end
	else
		writeln('el empleado ya existe');
end;


procedure bajaEmpleado(var a:tArchivo);
var
	numeroABorrar,pos:integer;
	cabecera,e:empleado; //el de cabecera para actualizar la lista 
begin
	writeln('ingrese el numero de empleado a borrar: ');
	readln(numeroABorrar);
	pos:=existeEmpleado(a,numeroABorrar);
	if(pos <> 0)then begin // si es distinto de 0 es porque existe el empleado a borrar 
		reset(a);
		read(a,cabecera);
		read(a,e);
		while(e.numero <> numeroABorrar)do
			read(a,e);
		seek(a,filePos(a)-1);
		//seek(a,filePos(pos));//me ubico en lugar donde se encuentra el registro a dar de baja(esto no se puede el filePos solo admite archivos)
		write(a,cabecera);//escribo el registro cabecera
		cabecera.numero:=(filePos(a)-1)*-1; // cambio su numero a negativo para marcar la baja
		seek(a,0);
		write(a,cabecera);//lo escribo al principio del archivo , lo actualizo
		close(a);
	end
	else
		writeln('empleado no existente');
end;


BEGIN	
END.

