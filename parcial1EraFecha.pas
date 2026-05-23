{Enunciado
Una plataforma digital organiza cada año una serie de eventos de sesiones musicales en vivo.
Cada evento cuenta con múltiples presentaciones realizadas en distintas fechas, y un mismo
artista puede participar varias veces en el mismo evento un mismo año.
Se dispone de un archivo que contiene la información de cada presentación individual. Cada
registro indica: el código del artista, el nombre del artista, el año en el que se realizó la
presentación, el código del evento, el nombre del evento, la cantidad de "likes" recibidos durante
esa presentación, la cantidad de "dislikes" recibidos, y el puntaje otorgado por el jurado técnico a
dicha presentación. El archivo está ordenado por año, luego por código de evento, y finalmente
por código de artista.
Se solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo y
genere un informe por pantalla con el siguiente formato de ejemplo:
Resumen de menor influencia por evento.
Año: 2022
Evento: nombreEvento1 (Código: códigoEvento1)
Artista: nombreArtista1 (Código: códigoArtista1)
Likes totales: total likes artista 1
Dislikes totales: total dislikes artista 1
Diferencia: diferencia (likes totales - dislikes totales) de artista 1
Puntaje total del jurado: puntaje total obtenido por el artista 1
...
Artista: nombreArtistaN (Código: códigoArtistaN)
idem anterior pero para artista N
El artista “nomArtistaMenosInfluyente” fue el menos influyente de nombreEvento1 del año 2022.
...
Evento: nombreEventoN (Código: códigoEventoN)
idem anterior para cada artista en el evento N

Durante el año 2022 se registraron “nroPresentaciones” de presentaciones de artistas.
...
Año: N
idem anterior para cada evento del año N
Durante el año N se registraron “nroPresentaciones” de presentaciones de artistas.
El promedio total de presentaciones por año es de: “promedioPresentacionesPorAño” presentaciones.

Nota: El artista menos influyente del evento, es aquel con menor puntaje total del jurado
acumulado. En caso de empate, se debe elegir al que haya recibido más dislikes,
independientemente de la diferencia. En caso de que haya empate nuevamente, elegir
cualquiera de los que tiene el menor puntaje total del jurado y la mayor cantidad de dislikes.}

program untitled;
const
	valorAlto = 9999;
	Max=-1;
type
	str30=string[30];
	TRegistro=record
		codA:integer;
		nomA:str30;
		anioP:integer;
		codE:integer;
		nomE:str30;
		cantLikes:longInt;
		cantDislikes:longInt;
		puntaje:real;
	end;
	
	TArchivo = file of TRegistro;

procedure leer(var a:TArchivo ; var dato:TRegistro);
begin
	if(not EOF(a))then
		read(a,dato)
	else
		dato.anioP := valorAlto;
end;

procedure informe(var a:TArchivo);
var
	reg,act:TRegistro;
	anios,presentacionesAnio,presentacionesTotal:integer;
	puntajeMin:real;
	nomArtista:str30;
	dislikesMax:longInt;
begin
	anios:=0;//anios totales en el archivo
	reset(a);
	leer(a,reg);
	presentacionesTotal:=0; //presentaciones totales con todos los años
	writeln('Resumen de menor influencia por evento');
	while(reg.anioP <> valorAlto)do begin   //primer while para fijarme el fin de archivo
		act.anioP:=reg.anioP;
		writeln('año: ',act.anioP); //año donde realizo el corte de control
		anios:=anios + 1;
		presentacionesAnio:=0; //cant presentaciones por año
		while(act.anioP = reg.anioP) do begin  // uso el otro registro como auxiliar para llevar a cabo el informe,primero se ordena por año
			act.codE:=reg.codE;
			act.nomE:=reg.nomE;
			puntajeMin:=valorAlto;
			dislikesMax:=Max;
			while(act.anioP = reg.anioP)and(act.codE = reg.codE) do begin // uso el codigo de evento(es el segundo orden del archivo)  
				act.nomA:=reg.nomA;
				act.codA:=reg.codA;
				act.cantLikes:=0;
				act.cantDislikes:=0;
				act.puntaje:=0;
				writeln('Artista: ',nomA,'(CODIGO: ',act.codA,')');
				while(act.anioP = reg.anioP)and(act.codE = reg.codE)and(act.codA = reg.codA)do begin// uso el codigo de artista(es el tercer orden del archivo) 
					act.catnLikes := act.cantLikes + reg.cantLikes;
					act.cantDislikes := act.cantDislikes + reg.cantDislikes;
					act.puntaje := act.puntaje + reg.puntaje;
					presentacionesAnio := presentacionesAnio + 1;
					leer(a,reg);//sigo leyendo el archivo para no generar bucle infinito
				end;
				if(act.puntaje < puntajeMin)or((act.puntaje = puntajeMin)and(act.cantDislikes > dislikesMax))then begin // me llevo al artista con mas dislikes e igual puntaje o menor puntaje
					puntajeMin:=act.puntaje;
					dislikesMax:=act.cantDislikes;
					nombreArtista:=act.nomA;
				end;
				writeln('Likes totales: ', act.cantLikes);
				writeln('Dislikes totales: ', act.cantDislikes);
				writeln('Diferencia: ', (act.cantLikes - act.cantDislikes));
				writeln('Puntaje total del jurado: ', act.puntaje);
			end;
			writeln('El artista ', nomA, ' fue el menos influyente de ', act.nomE,' del año ', act.anioP, '.');
		end;
		writeln('Durante el año ', act.anioP, ' se registraron ', presentacionesAnio, ' de presentaciones de artistas.');
		presentacionesTotal := presentacionesTotal + presentacionesAnio;
	end;
	if(anios > 0)then
		writeln('El promedio total de presentaciones por año es de: ', (presentacionesTotal / anios):0:2, ' presentaciones.')
	else
		writeln('No se registraron presentaciones.');
	close(a);
end;

var
	archivo:TArchivo;
BEGIN
	informe(archivo);
END.

