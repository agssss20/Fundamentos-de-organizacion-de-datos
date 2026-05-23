{2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.
a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.
c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.
e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?
f. Suponga que desea buscar los alumnos que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?}

//Archivo índice como árbol B

program untitled;
const 
	M = ..//Orden del arbol
type
	alumno = record
		nombre:string;
		apellido:string;
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	
	nodo = record
		cant_claves:integer;//cant claves total;
		claves: array[1..M-1] of longint;//cantidad de claves por nodo
		enlaces: array[1..M-1] of integer;//cantidad de enlaces que me llevaran a otros nodos(estamos en un indice)
		hijos: array[1..M] of integer;//hijos por nodo
	end;
	
	TArchivoDatos = file of alumno;//archivo que contiene los alumnos
	arbolB = file of nodo;//indice como estructura de árbol B que ofrece acceso indizado por DNI de los alumnos
	
var
	archivoDatos:TArchivoDatos;
	archivoIndice:arbolB;

{B. N = (M-1) * A + (M-1) * A + M * B + C
    512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
    512 = 4M - 4 + 4M - 4 + 4M + 4
    512 = 12M - 4
    512 + 4 = 12M
    516 / 12 = M
    M = 43
    
El orden del arbol B es de 43.}


{C. Incrementar el orden del arbol B significa aumentar la cantidad de registros que caben en un nodo, en este caso indices a registros
en consecuencia, esto implica que nuestro arbol sea menos profundo, y que se requieran menos accesos (lecturas) a los nodos.}

{D. Se busca en el arbol la clave con DNI 12345678, aprovechando el criterio de orden, moviendonos a la izquierda si es menor o igual, y 
en caso contrario, a la derecha. Una vez hallada la clave, uso el NRR guardado en el enlace para buscar el registro en el archivo de datos.
}

{E. Si se deseara buscar un alumno por su numero legajo se deberia realizar una busqueda secuencial hasta encontrar el alumno con el legajo
solicitado. No tendria sentido en este caso, usar el indice que organiza el acceso el archivo de alumnos por DNI. Para brindar
acceso indizado al archivo de alumnos por numero de legajos, lo mas conveniente seria armar un nuevo arbol B pero con criterio de orden en 
base al legajo.}

{F.este tipo de búsquedas con apoyo de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos tiene como
problema que debo estar leyendo todo el arbol una y otra vez sus nodos cada vez que encuentre un dni entre estos valores. Esto
requiere demasiadas lecturas en el arbol B lo cual lo hace ineficiente(No hay una forma directa de ir de un 
valor al siguiente sin volver a recorrer desde arriba).
¿Solucion? Usar un arbol B+ , ¿Porque? Al tener las hojas enlazadas en cadena , recorro solo las hojas y no todos los nodos , ya que
tambien tengo claves que me sirven como separadores para saber donde se encontraran , como los datos estan en las hojas , una vez entre
en el rango de las del DNI pedido se que podre encontrar facilmente los demas DNI sin volver a recorrer el arbol entero.
}
