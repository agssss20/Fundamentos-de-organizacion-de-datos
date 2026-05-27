{
Considere que se tiene un archivo que contiene información de los préstamos otorgados por una
empresa financiera que cuenta con varias sucursales. Por cada préstamo se tiene la siguiente
información: número de sucursal donde se otorgó, DNI del empleado que lo otorgó, número de
préstamo, fecha de otorgación y monto otorgado. Cada préstamo otorgado por la empresa se
considera como una venta. Además, se sabe que el archivo está ordenado por los siguientes
criterios: código de sucursal, DNI del empleado y fecha de otorgación (en ese orden).

Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo de
datos y genere un informe en un archivo de texto con el siguiente formato.


Informe de ventas de la empresa
Sucursal <número sucursal>
Empleado: DNI <DNI empleado>
Año Cantidad de ventas Monto de ventas
............... ...................... .......................
Totales <Total ventas empleado> <Monto total empleado>
Empleado: DNI <DNI empleado>
.................
Cantidad total de ventas sucursal: .................
Monto total vendido por sucursal: .................
Sucursal <número sucursal>
...........
Cantidad de ventas de la empresa: ................
Monto total vendido por la empresa: ................


Notas:
* El archivo de datos se debe recorrer solo una vez.
* Para determinar el año de otorgación de un préstamo, puede asumir que existe una función
extraerAño(fecha) que, a partir de una fecha dada, devuelve el año de la misma.
* En la generación del archivo de texto solo interesa que aparezca la información requerida,
NO es necesario que se incluyan los espacios en blanco o tabulaciones que se incluyen en el
informe de modo como ejemplo.
}
//corregido
program untitled;
const 
	VA=9999;
type
	str30=string[30];
	prestamo=record
		numeroS:integer;
		dni:integer;
		numeroP:integer;
		fecha:str30;
		monto:real;	
	end;
	
	tArchivo = file of prestamo;

procedure leer(var a:tArchivo ; var p:prestamo);
begin
	if(not(EOF(a)))then
		read(a,p)
	else
		p.numeroS := VA;
end;

function extraerAnio(fecha):string; //asumo que existe
begin
end;

procedure generarTxt(var a:tArchivo);
var
	txt:text;
	nombre:string;
	cantVentas,cantVentasTotalEmpleado,cantTotalVentasSucursal,cantVentasEmpresa:integer;
	montoEmpresa,montoTotalEmpleado,montoTotalSucursal:real;
	p,act:prestamo;
begin
	reset(a);
	writeln('ingrese un nombre al archivo de texto: ');
	readln(nombre);
	assign(txt,nombre);
	rewrite(txt);
	montoEmpresa:=0;
	cantVentasEmpresa:=0;
	leer(a,p);
	writeln(txt,'Informe de ventas de la empresa');
	while(p.numeroS <> VA)do begin //mientras mi archivo no sea EOF
		act.numeroS := p.numeroS;
		writeln(txt,'Sucursal <',act.numeroS ,'>');
		montoTotalSucursal:=0;
		cantTotalVentasSucursal:=0;
		while(p.numeroS = act.numeroS)do begin
			act.dni := p.dni;
			act.numeroP := p.numeroP;
			writeln(txt,'Empleado: DNI <',act.dni,'>');
			cantVentasTotalEmpleado:=0;
			montoTotalEmpleado:=0;
			while(p.numeroS = act.numeroS)and(act.dni = p.dni)do begin
				act.fecha:=p.fecha;
				act.monto:=0;
				cantVentas:=0;
				while(p.numeroS = act.numeroS)and(act.dni = p.dni)and(act.fecha = p.fecha)do begin
					act.monto:=act.monto + p.monto;
					cantVentas:=cantVentas + 1;
					leer(a,p);
				end;
				//corte de control por cambio de fecha
				writeln(txt,'Año: ',extraerAnio(act.fecha), 'Cantidad de ventas: ',cantVentas ,'Monto de ventas: ',act.monto);
				cantVentasTotalEmpleado := cantVentasTotalEmpleado + cantVentas;
				montoTotalEmpleado := montoTotalEmpleado + act.monto;
			end;
			//corte de control por cambio de dni empleado
			writeln(txt,'Totales <',cantVentasTotalEmpleado,'>','<',montoTotalEmpleado,'>','Empleado: DNI <'act.dni'>');
			montoTotalSucursal := montoTotalSucursal + montoTotalEmpleado;
			cantTotalVentasSucursal := cantTotalVentasSucursal + cantVentasTotalEmpleado;
		end;
		//corte de control por cambio de sucursal
		writeln(txt,'Cantidad total de ventas sucursal:',cantTotalVentasSucursal,'Monto total vendido por sucursal:',montoTotalSucursal, 'Sucursal <',act.numeroS,'>');
		montoEmpresa := montoEmpresa +  montoTotalSucursal;
		cantVentasEmpresa:=cantVentasEmpresa+cantTotalVentasSucursal;
	end;
	//resultado de los valores de la empresa
	writeln(txt,'Cantidad de ventas de la empresa:',cantVentasEmpresa,'Monto total vendido por la empresa:',montoEmpresa);
	close(a);
	close(txt);
end;


BEGIN
END.

