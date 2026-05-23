{1. Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M.
a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
alumnos como un árbol B de orden M.
b. Suponga que la estructura de datos que representa una persona (registro de
persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el
valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
(en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número
entero, ignorar la parte decimal).
c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
información de los alumnos como un árbol B?
d. ¿Qué dato seleccionaría como clave de identificación para organizar los
elementos (alumnos) en el árbol B? ¿Hay más de una opción?
e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
encontrar un alumno por su clave de identificación en el peor y en el mejor de
los casos? ¿Cuáles serían estos casos?
f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas
lecturas serían necesarias en el peor de los casos?}


program ArbolBParte1Pract4;
const
	M=..//Orden del arbol
type
	alumno = record
		nombre:string;
		apellido:string;
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	
	//defino el nodo de mi Arbol B (la informacion , la cantidad de casillas e hijos que tendra)
	nodo = record
		cant_datos:integer; // cantidad de datos en total
		datos: array [1..M - 1]of alumno; //cada casilla de informacion que tendran los nodos
		hijos: array [1..M] of integer; //la cantidad de hijos que pueden tener mis nodos
	end;
	
	arbolB = file of nodo; //defino mi arbol B
var
	archivoDatos: arbolB;

{B. N = (M-1) * A + M * B + C
	512 = (M-1) * 64 + M * 4 + 4
	512 = 64M - 64 + 4M + 4
	512 + 64 - 4 = 68M
	572 / 68 = M
	M = 8.4
	
En un nodo del arbol B entrarian 7 registros persona, al ser un arbol B en orden 8.
}

{C. El valor de M determina la cantidad maxima de claves y de hijos que puede tener un nodo en el arbol B. Un valor mayor de
M resultara en nodos mas grandes y, por lo tanto, en una estructura de arbol B mas ancha y menos profunda. Por otro lado, un valor menor de
M resultara en nodos mas pequeños y en una estructura de arbol B mas profunda pero mas estrecha.}

{D. Los datos que seleccionaria como clave de identificacion para organizar los elementos en el arbol B serian tanto el DNI como el
legajo ya que son campos unicos de alumnos de la facultad.}

{E. En el mejor de los casos, se necesita de una unica lectura para encontrar un alumno por su clave de identificacion.
En el peor de los casos, se necesita de h lecturas(con h altura del arbol).}

{F. Si se desea buscar un alumno por un criterio diferente se debe tener en cuenta el arbol por completo, siendo necesarias n lecturas
en el peor de los casos, siendo n la cantidad total de nodos que hay en el arbol.}

