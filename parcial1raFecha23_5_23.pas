

program untitled;
type
	profesional = record
		dni:integer;
		nombre:string;
		apellido:string;
		sueldo:real;
	end;
	
	tArchivo = file of profesional;

procedure crear(var arch:tArchivo ; var info:TEXT);//creo el archivo maestro a traves del archivo de texto
var
	p:profesional;
begin
	reset(info);//abro el archivo de texto ya existente
	rewrite(arch);//creo el archivo maestro
	while(not(EOF(info)))do begin // leo hasta fin de archivo de texto
		readln(info,p.dni,p.sueldo,p.nombre);
		readln(info,p.apellido);
		write(arch,p);//escribo sobre el maestro
	end;
	close(arch); //cierro el archivo txt
	close(info); //guardo en el maestro
end;

function existeProfesional(var a:tArchivo ; dni:integer):boolean;
var
	ok:boolean;
	p:profesional;
begin
	reset(a);
	ok:=false;
	while(not(EOF(a))and(ok = false))do begin
		read(a,p);
		if(p.dni = dni)then
			ok:=true;
	end;
	close(a);
	existeProfesional:=ok;
end;

procedure agregar(var arch:tArchivo ; p:profesional);
var
	cabecera:profesional;
begin
	if(not ExisteProfesional(arch,p.dni))then begin //busco si existe el profesional
		reset(arch);
		read(arch,cabecera);//leo el archivo de cabecera
		if(cabecera.dni = 0)then begin // si el dni del cabecera es 0(no hay registros dados de baja) , agrego el registro a lo ultimo del archivo maestro
			seek(arch,filesize(arch));//me paro al final de archivo maestro
			write(arch,p);//lo escribo
		end
		else begin // si el cabecera tiene un registro dado de baja
			seek(arch,cabecera.dni*-1);// me ubico en la pos de ese espacio del registro dado de baja
			read(arch,cabecera);// leo el de cabecera
			seek(arch,filePos(arch)-1);// reubico el puntero para escribir el registro en su lugar correspondiente
			write(arch,p);//lo escribo
			seek(arch,0);// me paro al principio de archivo
			write(arch,cabecera); // actualizo el archivo de cabecera
		end;
		close(arch);//guardo los cambios
	end;
end;

procedure eliminar(var arch:tArchivo ; dni:integer; var bajas:TEXT);
var
	cabecera,p:profesional;
begin
	if(existeProfesional(arch))then begin//busco si el profesional existe
		reset(arch);
		read(arch,cabecera);
		read(arch,p);
		while(p.dni <> dni)do // busco el dni a borrar
			read(arch,p);
		seek(arch,filePos(arch)-1); //me reubico en la posicion del registro a borrar
		write(arch,cabecera); // escribo en el cabecera el registro que borre
		cabecera.dni:=(filePos(arch)-1)*-1; // le cambio el dni a negativo para luego usar el cabecera para saber la posicion a buscar en caso de alta
		seek(arch,0);// me paro al principio de archivo
		write(arch,cabecera);//guardo el cabecera
		writeln(bajas,p.dni, '' , p.sueldo:0:2, p.nombre);
		writeln(bajas, p.apellido);
		close(arch);//guardo los cambios en maestro
		end;
end;

procedure imprimirArchivo(var a:tArchivo);
var
	p:profesional;
begin
	reset(a);
	while(not(EOF(a)))do begin
		read(a,p);
		write(p.dni,'-');
	end;
	close(a);
end;

var
	a:tArchivo;
	txt,txtBajas:text;
	p:profesional;
BEGIN
	assign(a,'ArchivoMaestro');
	assign(txt,'profesionales.txt');
	crear(a,txt);
	assign(txtBajas,'bajas.txt');
	rewrite(txtBajas);
	p.dni:= 33;
    p.nombre:= 'Matias';
    p.apellido:= 'Guaymas';
    p.sueldo:= 100;
    eliminar(a,10,txtBajas);
    close(txtBajas);//guardo los cambios en el txt de bajas
    imprimirArchivo(a);
    agregar(a,p);
    writeln();
    imprimirArchivo(a);
END.

