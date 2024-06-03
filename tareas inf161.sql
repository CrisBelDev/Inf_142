/*/desplegar el titulo del libro y la cantidad en existencia, de cada uno de ellos*/
select Titulo, cantidad from libro

/*ordenar los libro en forma ascendente*/
select Titulo, cantidad from libro order by Titulo

/*desplegar los libros que tienen 20 o mas ejemplares*/
select titulo, cantidad from libro where cantidad>=20

/*desplegar los libros que han sido editados en año 2010 y tienen en existencia la cantidad de 20 ejemplares*/
select titulo,cantidad,fecha 
from libro 
where cantidad=20 and to_char(fecha,'yyyy') = 2010

/*desplegar los autores que tienen como letra inicial 'C' en su nombre*/
Select * From autor Where nombre like 'C%' Order by Apellido

/*2do avanze PRODUCTO CARTESIANO*/
select idedi, nombre
from editorial xe
where xe.nombre LIKE 'amazon'

/*ejemplo PRODUCTO CARTESIANO*/
select xl.codLibro, xl.titulo, xe.nombre
from editorial xe, libro xl
where xe.nombre LIKE 'amazon'
and xe.idedi = xl.idEdi

/* ____ ---- */
/*1*/
SELECT apellido,nombre,fecnaci
FROM estudiante
WHERE apellido LIKE '_o%a'
ORDER BY apellido

/*2*/
SELECT apellido,nombre,sexo,nacionalidad
FROM estudiante
WHERE sexo= 'FEMENINO' AND nacionalidad = 'ARGENTINA'
ORDER BY apellido;

/*3*/
SELECT *
FROM materia
WHERE semestre >= 4
ORDER BY descripcion;

/*4*/
SELECT paterno,materno,nombre,fecnaci
FROM docente
WHERE  to_char(fecnaci,'yyyy')>= 1965 AND to_char(fecnaci,'yyyy')<=1975
ORDER BY paterno;

/*5*/
Select sigla, diahora1, diahora2, idaula
From paralelo
Where idaula = 'A' 
AND (diahora1 LIKE 'JU%'
OR diahora2 LIKE 'JU%')
Order by sigla

/*6*/
Select sigla, diahora1, diahora2
From paralelo
Where 
(diahora1 LIKE '%08'
OR diahora2 LIKE '%08')


/* ejerccios 2da clase PRODUCTO CARTESIANO*/
/*1*/
Select xe.apellido, xe.nombre, xi.sigla
From estudiante xe, inscrito xi
Where xi.sigla LIKE'INF161'
AND xe.idestu = xi.idestu
Order by apellido
/* 2. Desplegar las materias que se dictan clases en el aula 'A'. ayudaaaaa*/

Select xm.sigla, xm.descripcion
From materia xm, paralelo xp, aula xa
Where xa.idaula = 'A'
AND xm.sigla = xp.sigla 
AND xp.idaula = xa.idaula

/* 3. Desplegar los docentes que son coordinadores de materias del 1er semestre y 4to semestre.*/
select d.paterno, d.materno, d.nombre, m.sigla
from docente d, materia m
where (m.semestre like '1' or m.semestre like '4')
and m.iddoc_cordi = d.iddoc

/*4. Desplegar los docentes del sexo Masculino que dictan clases en el aula 'C'.*/

select d.paterno, d.materno, d.nombre, p.idaula
from docente d, paralelo p
where d.sexo like 'MASCULINO' and p.idaula = 'C' AND p.iddoc = d.iddoc
Order by d.paterno

/*5. Desplegar alfabéticamente los estudiantes que obtuvieron por debajo de 6 puntos en la primera nota y están inscritos en inf161 o inf111.*/
SELECT xe.apellido,xe.nombre, xi.sigla, xi.nota1
FROM inscrito xi,estudiante xe
WHERE (xi.sigla='INF111' OR xi.sigla='INF161')
AND xi.nota1<6
AND xi.idestu=xe.idestu



/* 3ra clase */

/*1. Desplegar las materias troncales de la Carrera de Informática que pasan clases en aulas con capacidad mayor a 50 y menor a 80 alumnos. Se llaman troncales aquellas materias donde la sigla inicia con las letras INF. Ordenar por Sigla.
*/
SELECT p.sigla, p.idparalelo, a.capacidad 
FROM aula a, paralelo p 
WHERE a.idaula=p.idaula AND (a.capacidad>50 AND a.capacidad<80) AND p.sigla like 'INF%'
ORDER BY p.sigla

/*2. Desplegar los estudiantes de nacionalidad 'BOLIVIANA' que están cursando materias en el paralelo 'B'.*/
SELECT DISTINCT e.apellido,e.nombre,e.nacionalidad
FROM estudiante e, inscrito i
WHERE e.nacionalidad ='BOLIVIANA' AND i.idestu = e.idestu AND i.idparalelo = 'B'
ORDER BY e.apellido
/*3. Desplegar las Materias (Sigla y Paralelo) que pasan clases los días LUNES y VIERNES en laboratorios.*/
SELECT p.sigla, p.idparalelo, p.diahora1, p.diahora2,a.tipo
FROM paralelo p,aula a
WHERE p.idaula = a.idaula AND (p.diahora1 like 'LU%' AND p.diahora2 LIKE 'VI%') AND a.tipo='LABORATORIO'
ORDER BY p.sigla, p.idparalelo
/*4. Desplegar los estudiantes del sexo 'MASCULINO' inscritos en las materias de INF131 paralelo 'B', INF153 paralelo 'D' e INF161 paralelo 'A'.*/
SELECT e.apellido, e.nombre, i.sigla, i.idparalelo
FROM estudiante e, inscrito i
WHERE e.sexo = 'MASCULINO' AND ((i.sigla = 'INF131' AND i.idparalelo = 'B') OR (i.sigla = 'INF153' AND i.idparalelo = 'D') OR (i.sigla = 'INF161' AND i.idparalelo = 'A'))  AND i.idestu = e.idestu
ORDER BY e.apellido



/*4ta clase*/
/* ---------------------------------- */
SELECT xa.idautor , xe.codlibro
FROM autor xa, escribe xe
WHERE sexo LIKE 'FEMENINO'
AND xa.idautor = xe.ideautor

/*producto cartesiano de 3 tablas*/
SELECT *
FROM libro xl, 
(SELECT xa.idautor , xe.codlibro
FROM autor xa, escribe xe
WHERE sexo LIKE 'FEMENINO'
AND xa.idautor = xe.ideautor) tmp 

WHERE xl.codlibro = tmp.codlibro

/* otra forma de hacer producto cartesiano sin tablas temporales*/
SELECT xl.titulo
FROM autor xa, escribe xe, libro xl
WHERE sexo LIKE 'FEMENINO'
AND xa.idautor = xe.ideautor
AND xe.codlibro = xl.codlibro


/*nro de lista: 1024 */
/*1. Desplegar las materias que son dictadas por docentes que tienen la edad de 55 años o más. Desplegar ordenado por semestre y sigla de la materia.*/
SELECT m.sigla, m.descripcion, p.idparalelo, m.semestre
FROM materia m, paralelo p, docente d 
WHERE (2024 - to_char(d.fecnaci,'yyyy')) >= 55 
AND m.sigla = p.sigla
AND p.iddoc = d.iddoc
ORDER BY m.semestre, m.sigla


SELECT m.sigla, m.descripcion, tmp.idparalelo, m.semestre
FROM materia m, 
(SELECT  *
FROM  paralelo p, docente d 
WHERE (2024 - to_char(d.fecnaci,'yyyy')) >= 55 
AND p.iddoc = d.iddoc) tmp 
WHERE tmp.sigla = m.sigla
ORDER BY m.semestre, m.sigla

/*2. Listar alfabéticamente los docentes que dictan materias del primer, tercer y sexto semestre.*/
SELECT DISTINCT d.paterno, d.materno, d.nombre
FROM docente d, paralelo p, materia m  
WHERE (m.semestre = 1 OR m.semestre = 3 OR m.semestre = 6) 
AND d.iddoc = p.iddoc
AND p.sigla = m.sigla
ORDER BY d.paterno



SELECT DISTINCT tmp.paterno, tmp.materno, tmp.nombre
FROM materia m  , 
(SELECT DISTINCT *
FROM docente d, paralelo p
WHERE d.iddoc = p.iddoc) tmp
WHERE (m.semestre = 1 OR m.semestre = 3 OR m.semestre = 6) 
AND tmp.sigla = m.sigla
ORDER BY tmp.paterno
/*3. 3. Desplegar alfabéticamente los alumnos que están inscritos en materias del quinto semestre en el paralelo ‘A’.*/
SELECT e.apellido, e.nombre, e.nacionalidad, m.sigla
FROM estudiante e , inscrito i,materia m  
WHERE (m.semestre = 5 AND i.idparalelo LIKE 'A')
AND e.idestu = i.idestu
AND i.sigla = m.sigla
ORDER BY e.apellido



SELECT tmp.apellido, tmp.nombre, tmp.nacionalidad, m.sigla
FROM materia m  , 
(SELECT *
FROM estudiante e, inscrito i 
WHERE e.idestu = i.idestu) tmp
WHERE (m.semestre = 5 AND tmp.idparalelo LIKE 'A')
AND tmp.sigla = m.sigla
ORDER BY tmp.apellido


















