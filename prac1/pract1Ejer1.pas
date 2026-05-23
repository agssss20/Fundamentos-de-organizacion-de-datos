program  ejer1prac1;
type
	archivo = file of integer;
var
	arc_num:archivo;
	num:integer;
	nom:string[50];

BEGIN
	write('ingrese nombre del archivo: ');
	readln(nom);
	Assign(arc_num,nom);
	rewrite(arc_num);
	write('ingrese un numero entero: ');
	readln(num);
	while(num <> 3000)do begin
		write(arc_num,num);
		write('ingrese un numero entero: ');
		readln(num)
	end;
	close(arc_num);
END.

