program ejer3;
uses crt;
const
	valorAlto=9999;
	n=3;
type
	producto=record
		cod:integer;
		nombre:string;
		des:string;
		stockD:integer;
		stockM:integer;
		precio:real;
	end;
	
	//sucursal donde viene info para modificar el maestro gracias al detalle
	suc=record
		cod:integer;
		cantidadVendida:integer;//stock vendido hago stockD-cantVendida
	end;
	
	maestro=file of producto;
	detalle=file of suc;
	ar_detalle = array[1..n]of detalle;
	reg_detalle = array[1..n]of suc;
	
procedure leer(var arc_detalle:detalle ; var dato:suc);
begin
	if not eof(arc_detalle)then
		read(arc_detalle,dato)
	else
		dato.cod:=valorAlto;
end;

procedure minimo(var registro:reg_detalle ;var min:suc ; var deta:ar_detalle);
var
	i,indiceMin:integer;
begin
	indiceMin:=0;
	min.cod:=valorAlto;
	for i:= 1 to n do
		if(registro[i].cod <> valorAlto)then
			if(registro[i].cod < min.cod)then begin
				min:=registro[i];
				indiceMin:=i;
			end;
	if(indiceMin <> 0)then begin
		leer(deta[indiceMin],registro[indiceMin]);
	end;
end;

procedure actualizar(var arc_maestro:maestro ; var deta:ar_detalle; var registro:reg_detalle);
var
	min:suc;i:integer;aString:string;m:producto;cantVendida:integer;codActual:integer;
begin
	reset(arc_maestro);
	for i := 1 to n do begin
		Str(i,aString);//genero string del detalle
		Assign(deta[i],' detalle ' + aString);
		reset(deta[i]);
		leer(deta[i],registro[i]);//leo el primer registro de los 30 archivos y lo escribo en el array de registros 
		writeln(registro[i].cod);
	end;
	minimo(registro,min,deta);//obtengo el minimo
	while(min.cod <> valorAlto)do begin
		codActual:=min.cod;
		cantVendida:=0;
		while(min.cod = codActual)do begin
			cantVendida:=cantVendida + min.cantidadVendida;
			minimo(registro,min,deta);
		end;
		read(arc_maestro,m);
		while(m.cod <> codActual)do begin
			read(arc_maestro,m);
		end;
		seek(arc_maestro,filePos(arc_maestro)-1);//busco el puntero y lo ubico
		m.stockD:=m.stockD - cantVendida;//actualizo el stock
		write(arc_maestro,m);//actualizo maestro
	end;
	for i:=1 to n do
		close(deta[i]);
	close(arc_maestro);
end;

procedure hacerTxt(var arc_maestro:maestro ; var arcTxt:Text);
var
	p:producto;
begin
	reset(arc_maestro);
	rewrite(arcTxt);
	while not eof(arc_maestro)do begin
		read(arc_maestro,p);
		if(p.stockD < p.stockM)then
			with p do begin
				writeln(arcTxt,cod,' ',nombre,' ',des,' ',stockD,' ',stockM,' ',precio);
			end;
	end;
	close(arc_maestro);
	close(arcTxt);
end;


var
	arcTxt:Text;
	deta:ar_detalle;
	arc_maestro:maestro;
	registro:reg_detalle;
BEGIN
	Assign(arc_maestro,'maestro');
	Assign(arcTxt,'menosStock.txt');
	actualizar(arc_maestro,deta,registro);
	hacerTxt(arc_maestro,arcTxt);
END.

