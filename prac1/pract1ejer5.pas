program untitled;

uses crt;
type
	celu=record
		cod:integer;
		precio:real;
		marca:string;
		stockD:integer;
		stockM:integer;
		des:string;
		nombre:string;
	end;
	
	archivo=file of celu;
	
procedure ingresarNombre(var nombre:string);
begin
	write('ingrese nombre del archivo: ');readln(nombre);
	writeln('');
end;

procedure imprimir(c:celu);
begin
	with c do begin
		writeln('|codigo: ',cod,' |precio: ',precio:0:2,' |marca: ',marca);
		writeln('|stock disponible: ',stockD,' |stock minimo: ', stockM);
		writeln('|descripcion: ',des,' |nombre: ',nombre);
		writeln('');
	end;
end; 

procedure crear(var arc_log:archivo ; var carga:Text);
var
	c:celu;
begin
	writeln('inserte los datos en el orden establecido: ');
	reset(carga);
	rewrite(arc_log);
	while (not eof(carga))do begin
		with c do begin
			readln(carga,cod,precio,marca);
			readln(carga,stockD,stockM,des);
			readln(carga,nombre);
			write(arc_log,c);
		end;
	end;
	writeln('archivo cargado');
	writeln('');
	close(carga);
	close(arc_log);
end;
	
	
procedure menosStockMinimo(var arc_log:archivo);
var
	c:celu;
begin
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log,c);
		if(c.stockD < c.stockM)then begin
			imprimir(c);
		end;
	end;
	close(arc_log);
end;

procedure buscarCadena(var arc_log:archivo; cadena:string);
var
	c:celu;
	ok:boolean;
begin
	cadena:='' + cadena;//le agrega un espacio asi no se lee todo junto
	ok:=false;
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log,c);
		if(c.des = cadena)then begin
			imprimir(c);
			ok:=true;
		end;
	end;
	if(ok=false)then begin
		writeln('ningun celular tiene esa descripcion');writeln('');
	end;
	close(arc_log);
end;


procedure exportar(var arc_log:archivo;var celu2:Text);
var
	c:celu;
begin
	rewrite(celu2);
	reset(arc_log);
	while not eof(arc_log)do begin
		read(arc_log,c);
		with c do begin
			writeln(celu2,'|codigo: ',cod:10,' |precio: ',precio:10:2,' |marca: ',marca:10,' |stock disponible: ',stockD:10,
			' |stock minimo: ',stockM:10,' |descripcion: ',des:10,' |nombre: ',nombre:10);
		end;
	end;
	writeln('se exporto con exito');
	close(arc_log);
	close(celu2);
end;

procedure menu(var arc_log:archivo;var carga:Text ;var celu2:Text;nombre:string);
var 	
	opcion:integer;
	cadena:string;
begin
	writeln('ingrese por teclado la opcion a realizar ',nombre);
	writeln('');
	writeln('1) crear archivo');
	writeln('');
	writeln('2) mostrar en pantalla los datos de los celulares con stock menor al stock minimo');
	writeln('');
	writeln('3) mostrar en pantalla celulares cuya descripcion tenga una cadena de caracteres proporcionada por el usuario');
	writeln('');
	writeln('4) exportar archivo a "celulares2.txt"');
	writeln('');
	writeln('opcion elegida --> ');
	readln(opcion);
	writeln('');
	case opcion of 
		1:
			crear(arc_log,carga);
		2:
		begin
			menosStockMinimo(arc_log);
		end;
		3:
		begin
			write('ingrese la descripcion del celular a buscar: ');
			readln(cadena);
			writeln('');
			buscarCadena(arc_log,cadena);
		end;
		4:
		begin
			exportar(arc_log,celu2);
		end;
		else writeln('no se encuentra la opcion');
	end;
end;


var
	arc_log:archivo;
	carga,celu2:Text;
	nombre:string;
	letra:char;
	loop:boolean;
BEGIN
	loop:=true;
	textcolor(red);
	clrscr;
	ingresarNombre(nombre);
	Assign(arc_log,nombre);
	Assign(carga,'celulares.txt');
	Assign(celu2,'celulares2.txt');
	menu(arc_log,carga,celu2,nombre);
	while(loop)do begin
		writeln('');
		write('ingrese cualquier caracter para abrir el menu , ingrese e para cerrar consola: ');readln(letra);
		if(letra = 'E')or(letra='e')then
			loop:=false
		else begin
			clrscr;
				menu(arc_log,carga,celu2,nombre);
		end;
	end;
END.

