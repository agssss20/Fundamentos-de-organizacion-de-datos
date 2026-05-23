program pract1ejer2;
type
	archivo = file of integer;
	
procedure mostrarPantalla(var arc_num:archivo ; var cantM,cant:integer ; var promedio:real);
var
	num:integer;
begin
	reset(arc_num);//uso reset para abrir el archivo(no rewrite para crear otro)
	while not eof(arc_num)do begin
		cant:=cant+1;
		read(arc_num,num);
		promedio:=promedio + num;//estoy guardando la suma total en promedio para dsp dividirlo por la cant total de nums ingresados
		if(num < 1500)then
			cantM:=cantM+1;
		writeln(num);
	end;
	close(arc_num);
end;


var
	arc_num:archivo;
	nom:string[50];
	cantM:integer;
	promedio:real;
	cant:integer;
BEGIN
	promedio:=0;
	cant:=0;
	cantM:=0;
	write('nombre del archivo: ');
	readln(nom);
	Assign(arc_num,nom);//debo dar el nombre del archivo del ejercicio 1
	mostrarPantalla(arc_num,cantM,cant,promedio);
	writeln('cant de nums menores a 1500: ', cantM);
	writeln('promedio de nums ingresados: ', promedio/cant:0:2);
END.

