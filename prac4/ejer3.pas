{3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
considere que por un lado se tiene el archivo que contiene la información de los
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
siguientes incisos:
a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
qué?
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño.
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
específico haciendo uso de la estructura auxiliar (índice) que se organiza como
un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
estructurado como un árbol B?
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?}


{A. Todas las claves se encuentran encuentran unicamente en los nodos hoja. Los nodos internos  contienen las claves que se utilizan 
para dirigir la busqueda hacia el nodo hoja correspondiente .}

{B. Los nodos hoja contienen todas las claves del arbol B+ y un enlace adicional que apunta al siguiente nodo hoja en orden 
ascendente. Esto permite un recorrido secuencial rapido sobre las claves.}

//C

program untitled;
const 
	M=..//orden del arbol
type
	alumno = record
		nombre:string;
		apellido:string;
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	
	lista=^nodo;//genero ese puntero que utiliza el arbol B+ en sus nodos para un acceso mas rapido
	TArchivoDatos=file of alumno;
	
	nodo = record
		cant_claves:integer;//cant claves total;
		claves: array[1..M-1] of longint;//cantidad de claves por nodo
		enlaces: array[1..M-1] of integer;//cantidad de enlaces que me llevaran a otros nodos(estamos en un indice)
		hijos: array[1..M] of integer;//hijos por nodo
		sig:lista;//lo uso para tener las hojas enlazadas
	end;
	
	arbolB = file of nodo;//indice como estructura de árbol B+ que ofrece acceso indizado por DNI de los alumnos
	
var
	archivoDatos:TArchivoDatos;
	archivoIndice:arbolB;

{D. EL proceso de busqueda de un alumno con un DNI haciendo uso del arbol B+ , consiste en aprovechar el criterio
de orden y los separadores de los nodos internos , hasta encontrar el dato en la hoja. la diferencia con respecto a un arbol B
es que la busqueda siempre termina en un nodo hoja (terminal), y no en los nodos internos , al ser copias.}

{E. Al tener las hojas enlazadas en cadena , recorro solo las hojas y no todos los nodos , ya que
tambien tengo claves que me sirven como separadores para saber donde se encontraran , como los datos estan en las hojas , una vez entre
en el rango de las del DNI pedido se que podre encontrar facilmente los demas DNI sin volver a recorrer el arbol entero.}

{F. Ventajas: Recorrido secuencial directo(Al estar las hojas enlazadas y contener los datos reales, puedo recorrer todos los alumnos en orden sin volver al árbol)
Búsqueda por rango eficiente
Como vimos en la consigna anterior, buscar alumnos con DNI entre 40000000 y 45000000 es muy eficiente.
Un solo acceso a disco(Con los datos en las hojas: Acceso 1: Leer la hoja → dato disponible inmediatamente).
Desventajas:
Nodos hoja más grandes(Cada hoja debe almacenar todos esos campos por cada alumno. Esto significa que caben menos claves por nodo, lo que puede aumentar la altura del árbol.)
Mayor costo en actualizaciones
Si modifico un dato de un alumno (por ejemplo su legajo), debo:
1. Buscar la hoja correspondiente
2. Reescribir el nodo completo con todos sus datos
Solo eficiente para UN orden
Las hojas están ordenadas por DNI (la clave del índice). Si quiero recorrer secuencialmente por legajo o año de ingreso, la cadena de hojas no me sirve y pierdo la ventaja del recorrido secuencial.}
