--https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-coalesce/

create table PELICULAS(
ID INTEGER PRIMARY KEY,
NOMBRE VARCHAR(255),
ANNO INTEGER
);

CREATE TABLE TAGS(
ID INTEGER PRIMARY KEY,
TAG VARCHAR(32)
);

create table PELICULAS_TAGS(
PELICULAS_ID INTEGER,
TAGS_ID INTEGER,
FOREIGN KEY (PELICULAS_ID) REFERENCES PELICULAS(ID),
FOREIGN KEY (TAGS_ID) REFERENCES TAGS(ID)  
);

INSERT INTO PELICULAS VALUES (1,'EL SEÑOR DE LOS ANILLOS', 2012);
INSERT INTO PELICULAS VALUES (2,'CAZAFANTASMAS', 2013);
INSERT INTO PELICULAS VALUES (3,'MARIO BROSS', 2022);
INSERT INTO PELICULAS VALUES (4,'ANT-MAN', 2020);
INSERT INTO PELICULAS VALUES (5,'IRON MAN', 2016);

INSERT INTO TAGS VALUES (1,'TERROR');
INSERT INTO TAGS VALUES (2,'ACCION');
INSERT INTO TAGS VALUES (3,'FICCION');
INSERT INTO TAGS VALUES (4,'ANIMACION');
INSERT INTO TAGS VALUES (5,'NIÑOS');

INSERT INTO PELICULAS_TAGS VALUES (1,4);
INSERT INTO PELICULAS_TAGS VALUES (1,2);
INSERT INTO PELICULAS_TAGS VALUES (1,3);
INSERT INTO PELICULAS_TAGS VALUES (2,1);
INSERT INTO PELICULAS_TAGS VALUES (2,5);

--Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.

SELECT DISTINCT(peliculas.nombre) AS PELICULAS_NOMBRE, COUNT(peliculas_tags.tags_id) as count_tags FROM PELICULAS
INNER JOIN peliculas_tags ON peliculas.id = peliculas_tags.peliculas_id
INNER JOIN tags ON peliculas_tags.tags_id = tags.id
WHERE peliculas.id = peliculas_tags.peliculas_id
group BY PELICULAS_NOMBRE;

create table PREGUNTAS(
ID INTEGER PRIMARY KEY,
PREGUNTA VARCHAR(255),
RESPUESTA_CORRECTA VARCHAR
);

CREATE TABLE USUARIOS(
ID INTEGER PRIMARY KEY,
NOMBRE VARCHAR(255),
EDAD INTEGER
);

CREATE TABLE RESPUESTAS(
ID INTEGER PRIMARY KEY,
RESPUESTA VARCHAR(255),
USUARIO_ID INTEGER,
PREGUNTAS_ID INTEGER,
FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID),
FOREIGN KEY (PREGUNTAS_ID) REFERENCES PREGUNTAS(ID)
);

--Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
--dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
--correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
--
--a. Contestada correctamente significa que la respuesta indicada en la tabla
--respuestas es exactamente igual al texto indicado en la tabla de preguntas.

INSERT INTO USUARIOS VALUES(1,'ROMINA',28);
INSERT INTO USUARIOS VALUES(2,'ALFONSO',26);
INSERT INTO USUARIOS VALUES(3,'ROBERTO',34);
INSERT INTO USUARIOS VALUES(4,'KARLA',29);
INSERT INTO USUARIOS VALUES(5,'PEDRO',49);

INSERT INTO PREGUNTAS VALUES(1,'¿QUIEN ES ESE POKEMON?','PICACHU');
INSERT INTO PREGUNTAS VALUES(2,'¿CUANTOS AÑOS TIENE PATRICIA MALDONADO?','9000');
INSERT INTO PREGUNTAS VALUES(3,'¿QUE FESTIVAL COBRA MAS CARO EN CHILE?','LOLLAPALOOZA');
INSERT INTO PREGUNTAS VALUES(4,'¿QUE AÑO FUE EL GOLPE DE ESTADO EN CHILE?','1973');
INSERT INTO PREGUNTAS VALUES(5,'¿PLATANO ES, ORO NO ES...QUE ES?','PLATANO');

INSERT INTO RESPUESTAS VALUES (1,'PICACHU',1,1);
INSERT INTO RESPUESTAS VALUES (2,'PICACHU',2,1);
INSERT INTO RESPUESTAS VALUES (3,'9000',3,2);
INSERT INTO RESPUESTAS VALUES (4,'BRONCE',4,5);
INSERT INTO RESPUESTAS VALUES (5,'2020',5,4);

--Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT DISTINCT(usuarios.nombre) AS nombre_usuario, count(respuestas) AS respuestas_correctas FROM usuarios
INNER JOIN respuestas on usuarios.id = respuestas.usuario_id
INNER JOIN preguntas on respuestas.preguntas_id = preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY nombre_usuario;

--Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.

SELECT preguntas.id AS PREGUNTA_id, COUNT(usuarios.id) as respuesta_usuarios_correcta FROM usuarios
INNER JOIN respuestas on usuarios.id = respuestas.usuario_id
INNER JOIN preguntas on respuestas.preguntas_id = preguntas.id
where respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY pregunta_id;

--Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.

delete from respuestas where usuario_id = 1;
DELETE from usuarios WHERE usuarios.id = 1;

-- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos. 

ALTER TABLE usuarios
ADD CONSTRAINT edadRestriccion CHECK (edad>18);

--Altera la tabla existente de usuarios agregando el campo email con la restricción de único.

alter table usuarios add email VARCHAR UNIQUE;