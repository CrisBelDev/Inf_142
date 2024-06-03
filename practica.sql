/*1*/
SELECT apellido, nombre, fnacimiento
FROM cliente
WHERE (apellido LIKE 'A%' OR apellido LIKE 'Z%') AND sexo = 'FEMENINO'
ORDER BY apellido
/*2*/
SELECT apellido, nombre, 2024 - TO_CHAR(fnacimiento, 'YYYY') AS edad
FROM cliente
WHERE nombre LIKE 'A_____';
/*3*/
SELECT idhabitacion,piso,tipo,costo 
FROM habitacion
WHERE tipo like 'VIP' AND costo >= 80 AND (piso = 4 OR piso = 5)
/*4 esta bein pero el orden varia....... */
SELECT apellido, nombre, fnacimiento
FROM cliente
WHERE TO_DATE(TO_CHAR(fnacimiento, 'DD-MM'), 'DD-MM') 
BETWEEN TO_DATE('23-10', 'DD-MM') AND TO_DATE('21-11', 'DD-MM')
ORDER BY apellido
/*5*/ 
SELECT apellido, nombre, ingreso
FROM cliente
WHERE (TO_CHAR(fnacimiento, 'YYYY') = '1990' OR TO_CHAR(fnacimiento, 'YYYY') = '2000')
AND ingreso >= 1000 AND ingreso < 2000
ORDER BY apellido
/*6*/
SELECT c.apellido, c.nombre, s.descripcion
FROM cliente c, se_hospeda sh, hab_ser hs, servicio s
where c.idcliente = sh.idcliente AND sh.idhabitacion = hs.idhabitacion AND hs.idservicio = s.idservicio AND s.descripcion ='KARAOKE'
ORDER BY c.apellido
/*7 Desplegar a los clientes de nacionalidad colombiana que están ocupando habitaciones
de tipo VIP.*/
SELECT c.idcliente, c.apellido, c.nombre, h.tipo
FROM cliente c,se_hospeda sp, habitacion h, pais p
WHERE c.idcliente = sp.idcliente AND sp.idhabitacion = h.idhabitacion AND h.tipo LIKE 'VIP' AND p.idpais = c.idpais AND p.nombre LIKE 'COLOMBIA'

/*8. Desplegar los clientes del sexo ‘MASCULINO’ que tienen el menor ingreso.*/
SELECT nombre, apellido, ingreso
FROM cliente
WHERE ingreso = (SELECT MIN(c.ingreso)
                FROM cliente c 
                WHERE c.sexo LIKE 'MASCULINO') 
AND sexo LIKE 'MASCULINO'
/*9. Desplegar al cliente que tiene el mayor de los ingresos, de los huéspedes que
ingresaron en el mes de julio del 2013.*/
SELECT nombre,apellido,ingreso,fechaingreso
FROM cliente , se_hospeda
WHERE ingreso = (SELECT MAX(c.ingreso)
                FROM cliente c,se_hospeda sp
                WHERE c.idcliente = sp.idcliente AND TO_CHAR(fechaingreso, 'YYYY') = '2013' AND  TO_CHAR(fechaingreso, 'MM') = '07'
                )
AND cliente.idcliente = se_hospeda.idcliente

/*10.Desplegar la cantidad de clientes por país.*/
SELECT p.idpais, p.nombre, tmp.nro
FROM pais p, (SELECT idpais ,COUNT(*) as nro
            FROM cliente 
            GROUP BY idpais
            ORDER by idpais) tmp 
WHERE p.idpais = tmp.idpais
/*11. Desplegar la cantidad de huéspedes por tipo de habitación.*/
SELECT h.tipo, COUNT(*)
FROM se_hospeda sp , habitacion h
WHERE sp.idhabitacion = h.idhabitacion
GROUP BY h.tipo

/*12.Listar los clientes que se hospedan en las habitaciones que hicieron uso de más de dos
servicios.*/
select tmp.apellido,tmp.nombre
from (	select xcl.apellido,xcl.nombre, COUNT(*)
		from cliente xcl, se_hospeda xho, habitacion xha, hab_ser xhs, servicio xs
		where xcl.idcliente=xho.idcliente and xho.idhabitacion=xha.idhabitacion 
		and xha.idhabitacion=xhs.idhabitacion and xhs.idservicio=xs.idservicio
		group by xcl.apellido,xcl.nombre
		having COUNT(*)>2)tmp
order by 1

/*13.  */

select tmp2.apellido,tmp2.nombre
from (	select tmp.apellido,tmp.nombre
		from (	select xcl.apellido,xcl.nombre, COUNT(*)
				from cliente xcl, se_hospeda xho, habitacion xha, hab_ser xhs, servicio xs
				where xcl.idcliente=xho.idcliente and xho.idhabitacion=xha.idhabitacion 
				and xha.idhabitacion=xhs.idhabitacion and xhs.idservicio=xs.idservicio
				group by xcl.apellido,xcl.nombre
				having COUNT(*)>2)tmp)tmp1,
(		select distinct xcl.apellido, xcl.nombre
		from cliente xcl, pais xp
		where xcl.idpais=xp.idpais and
		(xp.nombre='ARGENTINA' or xp.nombre='URUGUAY'))tmp2
where tmp1.apellido=tmp2.apellido and tmp1.nombre=tmp2.nombre
order by 1

/*14. */
select xp.idpais, xp.nombre, xcl.apellido, xcl.nombre, xcl.nombre, xcl.fnacimiento
from cliente xcl, pais xp, (select xp.idpais, xp.nombre, MAX(2024-to_char(xcl.fnacimiento,'yyyy'))EDAD
from cliente xcl, pais xp
where xcl.idpais=xp.idpais
group by xp.idpais, xp.nombre)tmp
where xcl.idpais=xp.idpais
and tmp.EDAD = 2024-to_char(xcl.fnacimiento,'yyyy') and tmp.idpais=xp.idpais
order by 1

/*15. */
SELECT 
    h.piso,
    COUNT(CASE WHEN c.sexo = 'FEMENINO' THEN 1 END) as nrof,
    COUNT(CASE WHEN c.sexo = 'MASCULINO' THEN 1 END) as nrom,
    COUNT(*) as total
FROM cliente c, se_hospeda sp , habitacion h
WHERE c.idcliente = sp.idcliente AND sp.idhabitacion = h.idhabitacion
GROUP BY h.piso
ORDER BY h.piso

/*16. */
SELECT c.apellido,c.nombre
FROM (SELECT xsp.idhabitacion, COUNT(*) as vecesocupado
        FROM se_hospeda xsp
        GROUP BY xsp.idhabitacion
    ) tmp, cliente c, se_hospeda sp1
WHERE vecesocupado = (SELECT MAX(tmp2.vecesocupado) 
                        FROM    (SELECT xsp.idhabitacion, COUNT(*) as vecesocupado
                                FROM se_hospeda xsp
                                GROUP BY xsp.idhabitacion) 
                                tmp2)
AND c.idcliente = sp1.idcliente AND sp1.idhabitacion = tmp.idhabitacion
ORDER BY c.apellido

/*17. */
SELECT sexo , AVG(ingreso) AS ingreso_promedio
FROM cliente
GROUP BY sexo

/*18. */
SELECT 
    sp.idhabitacion,
    sp.fechaingreso,
    h.costo,
    TO_DATE('15-08-2013', 'DD-MM-YYYY') - sp.fechaingreso AS NRODIAS,
    h.costo * (TO_DATE('15-08-2013', 'DD-MM-YYYY') - sp.fechaingreso) AS total
FROM 
    habitacion h,
    se_hospeda sp
WHERE 
    h.idhabitacion = sp.idhabitacion 
    AND sp.fechaingreso >= TO_DATE('01-08-2013', 'DD-MM-YYYY') 
    AND sp.fechaingreso < TO_DATE('15-08-2013', 'DD-MM-YYYY')
ORDER BY 
    sp.idhabitacion ASC,
    sp.fechaingreso DESC,
    NRODIAS DESC;



