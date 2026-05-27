//corregido
program untitled;
type
	mascota=record
		cod:integer;
		nombre:string;
		especie:string;
		edad:integer;
		nombreD:string;
		telefono:integer;
	end;
	
	tArchivo = file of mascota;//archivo de mascotas
	

	
function existeMascota(var a:tArchivo  ; cod:integer ):integer;
var
	pos:integer;
	m:mascota;
begin
	pos:=0;
	reset(a);
	read(a,m);//leo el de cabecera
	while(not(EOF(a))and(cod <> m.cod))do begin
		read(a,m);
		if(cod = m.cod)then
			pos:=(filePos(a)-1);
	end;
	close(a);
	existeMascota:=pos;
end; 

procedure altaMascota(var a:tArchivo);
var
	cabecera:mascota;
	m:mascota;
begin
	writeln('ingrese datos de la mascota a agregar: ');//leo la mascota a desear de dar de alta
	readln(m.cod,m.nombre,m.especie);
	readln(m.edad,m.nombreD,m.telefono);
	if(existeMascota(a,m.cod) = 0)then begin //si es 0 es porque no existe
		reset(a);
		read(a,cabecera); //uso mi registro cabecera con mi lista invertida para poner el registro a dar de alta en el lugar deseado
		if(cabecera.cod = 0 )then begin
			seek(a,fileSize(a));
			write(a,m);//lo pongo al final si el registro de cabecera me indica que no hubo registros dados de baja
		end
		else begin//si hubo un registro borrado
			seek(a,cabecera.cod*-1); // me paro en ese lugar usando el codigo del cabecera pasandolo de negativo a positivo
			read(a,cabecera);//leo el de cabecera
			seek(a,filePos(a)-1);//me reubico el puntero
			write(a,m);//escribo el registro a dar de alta
			seek(a,0);//me paro al principio de archivo
			write(a,cabecera);//actualizo el registro cabecera
		end;
		close(a);
	end
	else
		writeln('la mascota ya existe');
end;

procedure bajaMascota(var a:tArchivo);
var
	codigoABorrar,pos:integer;
	cabecera,m:mascota; //el de cabecera para actualizar la lista 
begin
	writeln('ingrese el codigo de la mascota a borrar: ');
	readln(codigoABorrar);
	pos:=existeMascota(a,codigoABorrar);
	if(pos <> 0)then begin // si es distinto de 0 es porque existe la mascota a borrar 
		reset(a);
		read(a,cabecera);//salto el de cabecera
		read(a,m);//leo las mascotas que siguen
		while(m.cod <> codigoABorrar)do
			read(a,m);
		seek(a,filePos(a)-1);
		//seek(a,filePos(pos));//me ubico en lugar donde se encuentra el registro a dar de baja(esto no se puede el filePos solo admite archivos)
		write(a,cabecera);//escribo el registro cabecera
		cabecera.cod:=(filePos(a)-1)*-1; // cambio su dni a negativo para marcar la baja
		seek(a,0);
		write(a,cabecera);//lo escribo al principio del archivo , lo actualizo
		close(a);
	end
	else
		writeln('mascota no registrada');
end;


//si no lo pide es innecesario
var
	a:tArchivo;
BEGIN
	assign(a,'ArchivoMaestro');
	altaMascota(a);
	bajaMascota(a);
END.

