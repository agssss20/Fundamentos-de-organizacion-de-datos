{
1. Archivos Secuenciales

Parcial Tercera Fecha 08/08/2023

Una empresa dedicada a la venta de golosinas posee un archivo que contiene información
sobre los productos que tiene a la venta. De cada producto se registran los siguientes datos:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.

La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada
una de las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada
sucursal. De cada venta se registra código de producto y cantidad vendida. Se debe realizar
un procedimiento que actualice el stock en el archivo maestro con la información disponible
en los archivos detalles y que además informe en un archivo de texto aquellos productos
cuyo monto total vendido en el día supere los $10.000. En el archivo de texto a exportar, por
cada producto incluido, se deben informar todos sus datos. Los datos de un producto se
deben organizar en el archivo de texto para facilitar el uso eventual del mismo como un
archivo de carga.

El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de
datos y módulos usados en el mismo.

Notas:

● Todos los archivos se encuentran ordenados por código de producto.

● En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.

● Cada archivo detalle solo contiene productos que seguro existen en el archivo
maestro.

● Los archivos se recorren una sola vez. En el mismo recorrido, se debe realizar la
actualización del archivo maestro con los archivos detalles, así como la generación
del archivo de texto solicitado
}


program untitled;
const
	VA = 9999;
	N = 20; // cantidad de sucursales
type
    subRango = 1..N;
    
    infoMaestro = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;
    
    
    infoDetalle = record    
        codigo: integer;
        cant: integer;
    end;
    
    
    maestro = file of infoMaestro;
    
    detalle = file of infoDetalle;
    
    vecDetalles = array[subRango] of detalle;
    
    vecRegistros = array[subRango] of infoDetalle;//por cada detalle hay un registro
    
procedure leer(var det: detalle; var info: infoDetalle);//leo solo el detalle
begin
    if(not eof(det)) then
        read(det, info)
    else
        info.codigo:= VA;
end;


//busco el minimo para no romper el orden del maestro
procedure minimo(var vecDet: vecDetalles; var vecReg: vecRegistros; var min: infoDetalle);
var
    i, minPos: subRango;
begin
    min.codigo:= VA;
    for i:= 1 to N do
        if(vecReg[i].codigo < min.codigo) then
            begin
                min:= vecReg[i];
                minPos:= i;
            end;
    if(min.codigo <> VA) then
        leer(vecDet[minPos], vecReg[minPos]);
end;

procedure actualizarMaestro(var mae: maestro; var vecDet: vecDetalles; var txt: text);
var
    vecReg: vecRegistros;
    infoMae: infoMaestro;
    i: subRango;
    min: infoDetalle;
    productosComprados, stockActual: integer;
    precioActual: real;
begin
    assign(txt, 'informe.txt');
    rewrite(txt);
    for i:= 1 to N do
        begin
            reset(vecDet[i]);
            leer(vecDet[i], vecReg[i]);
        end;
    reset(mae);
    minimo(vecDet, vecReg, min);
    while(min.codigo <> VA) do
        begin
            read(mae, infoMae);
            while(infoMae.codigo <> min.codigo) do
                read(mae, infoMae);
            productosComprados:= 0;
            precioActual:= infoMae.precio;
            stockActual:= infoMae.stockActual;
            while(infoMae.codigo = min.codigo) do
                begin
                    if(stockActual > min.cant) then
                        begin
                            productosComprados:= productosComprados + min.cant;
                            stockActual:= stockActual - min.cant;
                        end
                    else
                        begin
                            productosComprados:= productosComprados + stockActual;
                            stockActual:= 0;
                        end;
                    minimo(vecDet, vecReg, min);
                end;
            infoMae.stockActual:= stockActual;
            if(productosComprados * precioActual > 10000) then
                writeln(txt, infoMae.codigo, ' ', precioActual:0:2, ' ', infoMae.stockActual, ' ', infoMae.stockMinimo, infoMae.nombre);
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    for i:= 1 to N do
        close(vecDet[i]);
    close(mae);
    close(txt);
end;



{CUIDADO : no es necesario pero lo hago igual

procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    p: infoDetalle;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with p do
                begin
                    readln(carga, codigo, cant);
                    write(det, p);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure crearDetalles(var vec: vecDetalles);
var
    i: subRango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;

procedure imprimirMaestro(var mae: maestro);
var
    p: infoMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            writeln('Codigo=', p.codigo, ' StockActual=', p.stockActual, ' StockMin=', p.stockMinimo, ' Precio=', p.precio:0:2, ' Nombre=', p.nombre);
        end;
    close(mae);
end;

procedure crearMaestro(var mae: maestro);
var
    txt: text;
    p: infoMaestro;
begin
    assign(txt, 'productos.txt');
    reset(txt);
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with p do
                begin
                    readln(txt, codigo, stockActual, stockMinimo, precio, nombre);
                    write(mae, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
//CUIDADO


var
    mae: maestro;
    vecDet: vecDetalles;
    txt: text;
begin
    crearMaestro(mae);
    crearDetalles(vecDet);
    actualizarMaestro(mae, vecDet, txt);
    imprimirMaestro(mae);
end.
}
begin
end.
