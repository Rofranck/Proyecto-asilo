-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-10-2022 a las 09:04:41
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `asilo`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_CAJA` (IN `FECHAINICIO` DATE, IN `FECHAFIN` DATE, IN `TIPO` VARCHAR(255))   SELECT
	caja.caja_id, 
	caja.caja_fregistro, 
	caja.caja_monto, 
	caja.caja_tipo, 
	caja.caja_descripcion, 
	usuario.usu_nombre
FROM
	caja
	INNER JOIN
	usuario
	ON 
		caja.usuario_id = usuario.usu_id
	where caja.caja_fregistro BETWEEN FECHAINICIO AND FECHAFIN AND caja.caja_tipo LIKE TIPO$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ENFERMERO` ()   SELECT
	personal_salud.personal_salud_id, 
	personal_salud.personal_salud_dpi, 
	personal_salud.personal_salud_nombre, 
	personal_salud.personal_salud_apellido, 
	personal_salud.personal_salud_celular, 
	personal_salud.personal_salud_fnacimiento, 
	personal_salud.personal_salud_direccion, 
	personal_salud.personal_salud_tipo,
	CONCAT_WS(' ',	personal_salud.personal_salud_apellido,	personal_salud.personal_salud_nombre) as enfermero
FROM
	personal_salud
	WHERE personal_salud.personal_salud_tipo='ENFERMERO(A)'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_ESPECIALIDAD` ()   SELECT
	especialidad.especialidad_id, 
	especialidad.especialidad_nombre, 
	especialidad.especialidad_fregistro, 
	especialidad.especialidad_estatus
FROM
	Especialidad$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_EXAMEN` ()   SELECT
	examen.examen_id, 
	examen.examen_nombre, 
	examen.examen_fregistro, 
	examen.examen_estatus, 
	examen.examen_precio
FROM
	examen$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_EXAMEN_FICHA` (IN `ID` INT)   SELECT
	examen_ficha.exaficha_id, 
	examen.examen_nombre, 
	examen_ficha.exaficha_fregistro, 
	examen_ficha.exaficha_resultado
FROM
	examen_ficha
	INNER JOIN
	examen
	ON 
		examen_ficha.examen_id = examen.examen_id
		where examen_ficha.ficha_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_EXAMEN_PACIENTE` (IN `ID` INT)   SELECT
	solicitud.paciente_id, 
	examen.examen_nombre, 
	examen_ficha.exaficha_fregistro, 
	examen_ficha.exaficha_cantidad
FROM
	examen_ficha
	INNER JOIN
	ficha_medica
	ON 
		examen_ficha.ficha_id = ficha_medica.ficha_id
	INNER JOIN
	solicitud
	ON 
		ficha_medica.solicitud_id = solicitud.solicitud_id
	INNER JOIN
	examen
	ON 
		examen_ficha.examen_id = examen.examen_id
		where solicitud.paciente_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_FICHA` ()   SELECT
	ficha_medica.ficha_id, 
	ficha_medica.ficha_fregistro, 
	ficha_medica.solicitud_id, 
	ficha_medica.usu_id, 
	ficha_medica.ficha_diagnostico, 
	ficha_medica.ficha_observacion, 
	ficha_medica.ficha_monto,
	ficha_medica.ficha_examen,
	CONCAT_WS(' ',paciente.paciente_apellido,paciente.paciente_nombre) as paci, 
	especialidad.especialidad_nombre, 
	CONCAT_WS(' ',personal_salud.personal_salud_apellido,personal_salud.personal_salud_nombre) as medi
FROM
	ficha_medica
	INNER JOIN
	solicitud
	ON 
		ficha_medica.solicitud_id = solicitud.solicitud_id
	INNER JOIN
	paciente
	ON 
		solicitud.paciente_id = paciente.paciente_id
	INNER JOIN
	especialidad
	ON 
		solicitud.especialidad_id = especialidad.especialidad_id
	INNER JOIN
	personal_salud
	ON 
		solicitud.medico_id = personal_salud.personal_salud_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICAMENTO_FICHA` (IN `ID` INT)   SELECT
	ficha_medicamento.fimedi_id, 
	ficha_medicamento.fimedi_nombre, 
	ficha_medicamento.fimedi_cantidad, 
	ficha_medicamento.ficha_id
FROM
	ficha_medicamento
	where ficha_medicamento.ficha_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_MEDICO` ()   SELECT
	personal_salud.personal_salud_id, 
	personal_salud.personal_salud_dpi, 
	personal_salud.personal_salud_nombre, 
	personal_salud.personal_salud_apellido, 
	personal_salud.personal_salud_celular, 
	personal_salud.personal_salud_fnacimiento, 
	personal_salud.personal_salud_direccion, 
	personal_salud.personal_salud_tipo, 
	CONCAT_WS(' ',	personal_salud.personal_salud_apellido,	personal_salud.personal_salud_nombre) AS medico, 
	personal_salud.especialidad_id, 
	especialidad.especialidad_nombre
FROM
	personal_salud
	INNER JOIN
	especialidad
	ON 
		personal_salud.especialidad_id = especialidad.especialidad_id
	WHERE personal_salud.personal_salud_tipo='MEDICO'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_PACIENTE` ()   SELECT
	paciente.paciente_id, 
	paciente.paciente_dpi, 
	paciente.paciente_nombre, 
	paciente.paciente_apellido, 
	paciente.paciente_celular, 
	paciente.paciente_fnacimiento, 
	paciente.paciente_direccion,
	CONCAT_WS(' ',paciente.paciente_apellido,paciente.paciente_nombre) as paci
FROM
	paciente$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SELECT_ENFERMERO` ()   SELECT personal_salud_id,CONCAT_WS(' ',personal_salud_apellido,personal_salud_nombre) from personal_salud where personal_salud_tipo='ENFERMERO(A)'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SELECT_ESPECIALIDAD` ()   SELECT
	especialidad.especialidad_id, 
	especialidad.especialidad_nombre
FROM
	especialidad$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SELECT_EXAMEN` ()   SELECT examen_id,examen_nombre,examen_precio from examen$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SELECT_MEDICO_BUSCAR` (IN `ID` INT)   SELECT personal_salud_id,CONCAT_WS(' ',personal_salud_apellido,personal_salud_nombre) from personal_salud where personal_salud_tipo='MEDICO' AND especialidad_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SOLICITUD` ()   SELECT
	solicitud.solicitud_id, 
	solicitud.usuario_id, 
	solicitud.especialidad_id, 
	solicitud.medico_id, 
	solicitud.enfermero_id, 
	solicitud.solicitud_motivo, 
	solicitud.solicitud_horario, 
	usuario.usu_nombre, 
	solicitud.paciente_id, 
	paciente.paciente_dpi, 
	CONCAT_WS(' ',paciente.paciente_apellido,paciente.paciente_nombre) AS paci, 
	CONCAT_WS(' ',medico.personal_salud_apellido,medico.personal_salud_nombre) AS medi, 
	CONCAT_WS(' ',	enfermero.personal_salud_apellido,enfermero.personal_salud_nombre) AS enfe, 
	especialidad.especialidad_nombre, 
	solicitud.solicitud_fregistro
FROM
	solicitud
	INNER JOIN
	usuario
	ON 
		solicitud.usuario_id = usuario.usu_id
	INNER JOIN
	paciente
	ON 
		solicitud.paciente_id = paciente.paciente_id
	INNER JOIN
	personal_salud AS medico
	ON 
		solicitud.medico_id = medico.personal_salud_id
	INNER JOIN
	personal_salud AS enfermero
	ON 
		solicitud.enfermero_id = enfermero.personal_salud_id
	INNER JOIN
	especialidad
	ON 
		solicitud.especialidad_id = especialidad.especialidad_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_SOLICITUD_FICHA` ()   SELECT
	solicitud.solicitud_id, 
	solicitud.usuario_id, 
	solicitud.especialidad_id, 
	solicitud.medico_id, 
	solicitud.enfermero_id, 
	solicitud.solicitud_motivo, 
	solicitud.solicitud_horario, 
	usuario.usu_nombre, 
	solicitud.paciente_id, 
	paciente.paciente_dpi, 
	CONCAT_WS(' ',paciente.paciente_apellido,paciente.paciente_nombre) AS paci, 
	CONCAT_WS(' ',medico.personal_salud_apellido,medico.personal_salud_nombre) AS medi, 
	CONCAT_WS(' ',	enfermero.personal_salud_apellido,enfermero.personal_salud_nombre) AS enfe, 
	especialidad.especialidad_nombre, 
	solicitud.solicitud_fregistro
FROM
	solicitud
	INNER JOIN
	usuario
	ON 
		solicitud.usuario_id = usuario.usu_id
	INNER JOIN
	paciente
	ON 
		solicitud.paciente_id = paciente.paciente_id
	INNER JOIN
	personal_salud AS medico
	ON 
		solicitud.medico_id = medico.personal_salud_id
	INNER JOIN
	personal_salud AS enfermero
	ON 
		solicitud.enfermero_id = enfermero.personal_salud_id
	INNER JOIN
	especialidad
	ON 
		solicitud.especialidad_id = especialidad.especialidad_id
		where solicitud.solicitud_estatus='PENDIENTE'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LISTAR_USUARIO` ()   SELECT
	usuario.usu_id, 
	usuario.usu_nombre, 
	usuario.usu_usuario, 
	usuario.usu_contrasena, 
	usuario.usu_rol, 
	usuario.usu_status, 
	usuario.usu_email
FROM
	usuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_CAJA` (IN `ID` INT, IN `FECHA` DATE, IN `MONTO` DECIMAL(10,2), IN `TIPO` VARCHAR(255), IN `DESCRIPCION` TEXT, IN `IDCAJA` INT)   UPDATE caja SET 
caja_fregistro=FECHA,
caja_monto=MONTO,
caja_tipo=TIPO,
caja_descripcion=DESCRIPCION,
usuario_id=ID
WHERE caja_id=IDCAJA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_ENFERMERO` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255), IN `ID` INT)   BEGIN
DECLARE DPIACTUAL CHAR(14);
DECLARE CANTIDAD INT;
SET @DPIACTUAL:=(SELECT personal_salud_dpi FROM personal_salud where personal_salud_id=ID);
IF @DPIACTUAL = DPI THEN
	UPDATE  personal_salud set 
	personal_salud_dpi=DPI,
	personal_salud_nombre=NOMBRES,
	personal_salud_apellido=APELLIDOS,
	personal_salud_celular=CELULAR,
	personal_salud_fnacimiento=FNACI,
	personal_salud_direccion=DIRECCION
	where personal_salud_id=ID;
	SELECT 1;
ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM personal_salud where personal_salud_dpi=DPI);
	IF @CANTIDAD = 0 THEN
	UPDATE  personal_salud set 
	personal_salud_dpi=DPI,
	personal_salud_nombre=NOMBRES,
	personal_salud_apellido=APELLIDOS,
	personal_salud_celular=CELULAR,
	personal_salud_fnacimiento=FNACI,
	personal_salud_direccion=DIRECCION
	where personal_salud_id=ID;
	SELECT 1;
	ELSE 
	SELECT 2;
	END IF;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_ESPECIALIDAD` (IN `ID` INT, IN `ESP` VARCHAR(25), IN `ESTATUS` VARCHAR(10))   BEGIN
DECLARE CANTIDAD INT;
DECLARE ESPACTUAL VARCHAR(25);
SET @ESPACTUAL:=(SELECT especialidad_nombre from especialidad where especialidad_id=ID);
IF @ESPACTUAL = ESP THEN
	UPDATE especialidad set
	especialidad_nombre=ESP,
	especialidad_estatus=ESTATUS
	where especialidad_id=ID;
	SELECT 1;
ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM especialidad where especialidad_nombre=ESP);
	if @CANTIDAD = 0 THEN
		UPDATE especialidad set
		especialidad_nombre=ESP,
		especialidad_estatus=ESTATUS
		where especialidad_id=ID;
		SELECT 1;
	ELSE
		SELECT 2;
	END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_EXAMEN` (IN `ID` INT, IN `EXAMEN` VARCHAR(100), IN `ESTATUS` VARCHAR(10), IN `PRECIO` DECIMAL(10,2))   BEGIN
DECLARE EXAMENACTUAL VARCHAR(100);
DECLARE CANTIDAD INT;
SET @EXAMENACTUAL:=(SELECT examen_nombre FROM examen where examen_id=ID);
IF @EXAMENACTUAL = EXAMEN THEN
	UPDATE examen set 
	examen_nombre=EXAMEN,
	examen_estatus=ESTATUS,
	examen_precio=PRECIO
	where examen_id=ID;
	SELECT 1;
ELSE
 SET @CANTIDAD:=(SELECT COUNT(*) FROM examen where examen_nombre=EXAMEN);
 IF @CANTIDAD = 0 THEN
 	UPDATE examen set 
	examen_nombre=EXAMEN,
	examen_estatus=ESTATUS,
		examen_precio=PRECIO
	where examen_id=ID;
	SELECT 1;
 ELSE
	SELECT 2;
 END IF;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_MEDICO` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255), IN `ID` INT, IN `IDESPE` INT)   BEGIN
DECLARE DPIACTUAL CHAR(14);
DECLARE CANTIDAD INT;
SET @DPIACTUAL:=(SELECT personal_salud_dpi FROM personal_salud where personal_salud_id=ID);
IF @DPIACTUAL = DPI THEN
	UPDATE  personal_salud set 
	personal_salud_dpi=DPI,
	personal_salud_nombre=NOMBRES,
	personal_salud_apellido=APELLIDOS,
	personal_salud_celular=CELULAR,
	personal_salud_fnacimiento=FNACI,
	personal_salud_direccion=DIRECCION,
	especialidad_id=IDESPE
	where personal_salud_id=ID;
	SELECT 1;
ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM personal_salud where personal_salud_dpi=DPI);
	IF @CANTIDAD = 0 THEN
	UPDATE  personal_salud set 
	personal_salud_dpi=DPI,
	personal_salud_nombre=NOMBRES,
	personal_salud_apellido=APELLIDOS,
	personal_salud_celular=CELULAR,
	personal_salud_fnacimiento=FNACI,
	personal_salud_direccion=DIRECCION,
	especialidad_id=IDESPE
	where personal_salud_id=ID;
	SELECT 1;
	ELSE 
	SELECT 2;
	END IF;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_PACIENTE` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255), IN `ID` INT)   BEGIN
DECLARE DPIACTUAL CHAR(14);
DECLARE CANTIDAD INT;
SET @DPIACTUAL:=(SELECT paciente_dpi FROM paciente where paciente_id=ID);
IF @DPIACTUAL = DPI THEN
	UPDATE  paciente set 
	paciente_dpi=DPI,
	paciente_nombre=NOMBRES,
	paciente_apellido=APELLIDOS,
	paciente_celular=CELULAR,
	paciente_fnacimiento=FNACI,
	paciente_direccion=DIRECCION
	where paciente_id=ID;
	SELECT 1;
ELSE
	SET @CANTIDAD:=(SELECT COUNT(*) FROM paciente where paciente_dpi=DPI);
	IF @CANTIDAD = 0 THEN
	UPDATE  paciente set 
	paciente_dpi=DPI,
	paciente_nombre=NOMBRES,
	paciente_apellido=APELLIDOS,
	paciente_celular=CELULAR,
	paciente_fnacimiento=FNACI,
	paciente_direccion=DIRECCION
	where paciente_id=ID;
	SELECT 1;
	ELSE 
	SELECT 2;
	END IF;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_SOLICITUD` (IN `IDSOLICITUD` INT, IN `HORARIO` DATETIME, IN `IDES` INT, IN `IDME` INT, IN `IDEN` INT, IN `MOTIVO` VARCHAR(255), IN `IDUSUARIO` INT)   UPDATE solicitud set 
solicitud_horario=HORARIO,
especialidad_id=IDES,
medico_id=IDME,
enfermero_id=IDEN,
solicitud_motivo=MOTIVO,
usuario_id=IDUSUARIO
where solicitud_id=IDSOLICITUD$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_USUARIO_CONTRA` (IN `ID` INT, IN `CONTRA` VARCHAR(255))   UPDATE usuario set
usu_contrasena=CONTRA
where usu_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MODIFICAR_USUARIO_ESTATUS` (IN `ID` INT, IN `ESTATUS` VARCHAR(10))   UPDATE usuario set
usu_status=ESTATUS
where usu_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_CAJA` (IN `ID` INT, IN `FECHA` DATE, IN `MONTO` DECIMAL(10,2), IN `TIPO` VARCHAR(255), IN `DESCRIPCION` TEXT)   INSERT INTO caja(caja_fregistro,caja_monto,caja_tipo,caja_descripcion,usuario_id) VALUES (FECHA,MONTO,TIPO,DESCRIPCION,ID)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ENFERMERO` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255), IN `ROL` VARCHAR(255), IN `CONTRA` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
DECLARE NUSUARIO INT;
SET @NUSUARIO:=(SELECT COUNT(*) FROM usuario where usu_usuario=DPI);
SET @CANTIDAD:=(SELECT COUNT(*) FROM personal_salud where personal_salud_dpi=DPI);
IF  @NUSUARIO = 0 THEN
	IF @CANTIDAD = 0 THEN
	INSERT INTO usuario(usu_nombre,usu_usuario,usu_contrasena,usu_rol,usu_status) VALUES(CONCAT_WS(' ',NOMBRES,APELLIDOS),DPI,CONTRA,ROL,'ACTIVO');
	INSERT INTO personal_salud(personal_salud_dpi,personal_salud_nombre,personal_salud_apellido,personal_salud_celular,personal_salud_fnacimiento,personal_salud_direccion,personal_salud_tipo,usuario_id) VALUES(DPI,NOMBRES,APELLIDOS,CELULAR,FNACI,DIRECCION,'ENFERMERO(A)',(select max(usu_id) from usuario));
	SELECT 1;
	ELSE 
	SELECT 2;
	END IF;
ELSE
 SELECT 1;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_ESPECIALIDAD` (IN `ESP` VARCHAR(25))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM especialidad where especialidad_nombre=ESP);
if @CANTIDAD = 0 THEN
INSERT into especialidad(especialidad_nombre,especialidad_fregistro,especialidad_estatus)values(ESP,CURDATE(),'ACTIVO');
SELECT 1;
ELSE
SELECT 2;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_EXAMEN` (IN `EXAMEN` VARCHAR(100), IN `PRECIO` DECIMAL(10,2))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM examen where examen_nombre=EXAMEN);
IF @CANTIDAD = 0 THEN
	INSERT INTO examen(examen_nombre,examen_fregistro,examen_estatus,examen_precio) VALUES(EXAMEN,CURDATE(),'ACTIVO',PRECIO);
	SELECT 1;
ELSE
	SELECT 2;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_EXAMEN_DETALLE` (IN `IDFICHA` INT, IN `IDEXAMEN` INT, IN `PRECIO` DECIMAL(10,2), IN `CANTIDAD` INT)   INSERT INTO examen_ficha(ficha_id,examen_id,exaficha_fregistro,exaficha_cantidad,exaficha_monto,exaficha_resultado) VALUES(IDFICHA,IDEXAMEN,CURDATE(),CANTIDAD,PRECIO,"")$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_FICHA_CON_EXAMEN` (IN `IDSOLI` INT, IN `FECHA` DATE, IN `DIAGNOSTICO` VARCHAR(255), IN `OBSERVACION` VARCHAR(255), IN `IDUSUARIO` INT, IN `TOTAL` DECIMAL(10,2))   BEGIN
UPDATE solicitud SET
solicitud_estatus='ATENDIDO'
where solicitud_id=IDSOLI;
INSERT INTO ficha_medica(solicitud_id,ficha_fregistro,ficha_diagnostico,ficha_observacion,ficha_monto,usu_id,ficha_examen)VALUES(IDSOLI,FECHA,DIAGNOSTICO,OBSERVACION,TOTAL,IDUSUARIO,'SI');
SELECT LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_FICHA_SIN_EXAMEN` (IN `IDSOLI` INT, IN `FECHA` DATE, IN `DIAGNOSTICO` VARCHAR(255), IN `OBSERVACION` VARCHAR(255), IN `IDUSUARIO` INT)   BEGIN
INSERT INTO ficha_medica(solicitud_id,ficha_fregistro,ficha_diagnostico,ficha_observacion,ficha_monto,usu_id,ficha_examen)VALUES(IDSOLI,FECHA,DIAGNOSTICO,OBSERVACION,0,IDUSUARIO,'NO');
UPDATE solicitud SET
solicitud_estatus='ATENDIDO'
where solicitud_id=IDSOLI;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_MEDICO` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255), IN `IDESPECIALIDAD` INT, IN `ROL` VARCHAR(255), IN `CONTRA` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
DECLARE NUSUARIO INT;
SET @NUSUARIO:=(SELECT COUNT(*) FROM usuario where usu_usuario=DPI);
SET @CANTIDAD:=(SELECT COUNT(*) FROM personal_salud where personal_salud_dpi=DPI);
IF  @NUSUARIO = 0 THEN
IF @CANTIDAD = 0 THEN
INSERT INTO usuario(usu_nombre,usu_usuario,usu_contrasena,usu_rol,usu_status) VALUES(CONCAT_WS(' ',NOMBRES,APELLIDOS),DPI,CONTRA,ROL,'ACTIVO');
INSERT INTO personal_salud(personal_salud_dpi,personal_salud_nombre,personal_salud_apellido,personal_salud_celular,personal_salud_fnacimiento,personal_salud_direccion,personal_salud_tipo,especialidad_id,usuario_id) VALUES(DPI,NOMBRES,APELLIDOS,CELULAR,FNACI,DIRECCION,'MEDICO',IDESPECIALIDAD,(select max(usu_id) from usuario));
SELECT 1;
ELSE 
SELECT 2;
END IF;
ELSE
SELECT 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_PACIENTE` (IN `DPI` CHAR(14), IN `NOMBRES` VARCHAR(255), IN `APELLIDOS` VARCHAR(255), IN `CELULAR` CHAR(14), IN `FNACI` DATE, IN `DIRECCION` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) FROM paciente where paciente_dpi=DPI);
IF @CANTIDAD = 0 THEN
INSERT INTO paciente(paciente_dpi,paciente_nombre,paciente_apellido,paciente_celular,paciente_fnacimiento,paciente_direccion) VALUES(DPI,NOMBRES,APELLIDOS,CELULAR,FNACI,DIRECCION);
SELECT 1;
ELSE 
SELECT 2;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_SOLICITUD` (IN `IDPACIENTE` INT, IN `HORARIO` DATETIME, IN `IDES` INT, IN `IDME` INT, IN `IDEN` INT, IN `MOTIVO` VARCHAR(255), IN `IDUSUARIO` INT)   INSERT INTO solicitud(paciente_id,solicitud_horario,especialidad_id,medico_id,enfermero_id,solicitud_motivo,usuario_id,solicitud_fregistro,solicitud_estatus) VALUES(IDPACIENTE,HORARIO,IDES,IDME,IDEN,MOTIVO,IDUSUARIO,CURDATE(),'PENDIENTE')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_USUARIO` (IN `USU` VARCHAR(255), IN `CONTRA` VARCHAR(255), IN `EMAIL` VARCHAR(255), IN `ROL` VARCHAR(255), IN `NOMBRES` VARCHAR(255))   BEGIN
DECLARE CANTIDAD INT;
SET @CANTIDAD:=(SELECT COUNT(*) from usuario where usu_usuario=USU);
IF @CANTIDAD = 0 THEN
	INSERT INTO usuario(usu_nombre,usu_usuario,usu_contrasena,usu_rol,usu_status,usu_email)
	VALUES(NOMBRES,USU,CONTRA,ROL,'ACTIVO',EMAIL);
	SELECT 1;
ELSE
  SELECT 2;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRA_MEDICAMENTO_FICHA` (IN `ID` INT, IN `MEDICAMENTO` VARCHAR(255), IN `CANTIDAD` INT)   insert into ficha_medicamento(ficha_id,fimedi_nombre,fimedi_cantidad) VALUES (ID,MEDICAMENTO,CANTIDAD)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SUBIR_RESULTADO_EXAMEN` (IN `ID` INT, IN `RUTA` VARCHAR(255))   UPDATE examen_ficha set
exaficha_resultado=RUTA
where exaficha_id=ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VERIFICAR_USUARIO` (IN `USU` VARCHAR(255))   SELECT
	usuario.usu_id, 
	usuario.usu_nombre, 
	usuario.usu_usuario, 
	usuario.usu_contrasena, 
	usuario.usu_rol, 
	usuario.usu_status, 
	usuario.usu_email
FROM
	usuario
	where usuario.usu_usuario = BINARY USU$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caja`
--

CREATE TABLE `caja` (
  `caja_id` int(11) NOT NULL,
  `caja_fregistro` date DEFAULT NULL,
  `caja_monto` decimal(10,2) DEFAULT NULL,
  `caja_tipo` varchar(255) DEFAULT NULL,
  `caja_descripcion` text DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `caja`
--

INSERT INTO `caja` (`caja_id`, `caja_fregistro`, `caja_monto`, `caja_tipo`, `caja_descripcion`, `usuario_id`) VALUES
(1, '2022-10-02', '170.00', 'COBROS', 'PAGO DONACION', 1),
(2, '2022-10-02', '100.00', 'PAGO A LA FUNDACION', 'PAGO MENSUAL A LA FUNDACION SIS', 1),
(3, '2022-10-14', '1522.00', 'PAGO A LA FUNDACION', 'DONACION ANINOMO', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidad`
--

CREATE TABLE `especialidad` (
  `especialidad_id` int(11) NOT NULL,
  `especialidad_nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `especialidad_fregistro` date DEFAULT NULL,
  `especialidad_estatus` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `especialidad`
--

INSERT INTO `especialidad` (`especialidad_id`, `especialidad_nombre`, `especialidad_fregistro`, `especialidad_estatus`) VALUES
(1, 'MEDICINA GENERAL', '2021-02-04', 'ACTIVO'),
(2, 'PSICOLOGIA', '2021-02-05', 'ACTIVO'),
(3, 'NUTRIOLOGO', '2022-10-25', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `examen`
--

CREATE TABLE `examen` (
  `examen_id` int(11) NOT NULL,
  `examen_nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `examen_fregistro` date DEFAULT NULL,
  `examen_estatus` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `examen_precio` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `examen`
--

INSERT INTO `examen` (`examen_id`, `examen_nombre`, `examen_fregistro`, `examen_estatus`, `examen_precio`) VALUES
(1, 'EXAMEN 123', '2021-02-01', 'ACTIVO', '100.00'),
(2, 'TOLERANCIA A LA GLUCOSA', '2021-02-01', 'ACTIVO', '20.00'),
(3, 'EXAMEN 2', '2021-02-25', 'ACTIVO', '25.00'),
(4, 'EXAMEN PRUEBA', '2022-08-03', 'ACTIVO', '15.00'),
(5, 'RADIO GRAFIA', '2022-10-25', 'ACTIVO', '2500.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `examen_ficha`
--

CREATE TABLE `examen_ficha` (
  `exaficha_id` int(11) NOT NULL,
  `ficha_id` int(255) DEFAULT NULL,
  `examen_id` int(11) DEFAULT NULL,
  `exaficha_fregistro` date DEFAULT NULL,
  `exaficha_resultado` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `exaficha_cantidad` int(11) DEFAULT NULL,
  `exaficha_monto` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `examen_ficha`
--

INSERT INTO `examen_ficha` (`exaficha_id`, `ficha_id`, `examen_id`, `exaficha_fregistro`, `exaficha_resultado`, `exaficha_cantidad`, `exaficha_monto`) VALUES
(1, 2, 1, '2022-10-17', 'controller/ficha/resultados/ARC1810202213840.pdf', 2, '100.00'),
(2, 2, 2, '2022-10-17', 'controller/ficha/resultados/ARC1810202219323.png', 3, '20.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ficha_medica`
--

CREATE TABLE `ficha_medica` (
  `ficha_id` int(11) NOT NULL,
  `ficha_fregistro` date DEFAULT NULL,
  `solicitud_id` int(11) DEFAULT NULL,
  `usu_id` int(11) DEFAULT NULL,
  `ficha_diagnostico` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `ficha_observacion` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `ficha_monto` decimal(10,2) DEFAULT NULL,
  `ficha_examen` char(2) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `ficha_medica`
--

INSERT INTO `ficha_medica` (`ficha_id`, `ficha_fregistro`, `solicitud_id`, `usu_id`, `ficha_diagnostico`, `ficha_observacion`, `ficha_monto`, `ficha_examen`) VALUES
(1, '2022-10-17', 1, 1, 'ASDASD', 'AASDASD', '0.00', 'NO'),
(2, '2022-10-17', 2, 1, 'ASDASD', 'ASDAS', '260.00', 'SI');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ficha_medicamento`
--

CREATE TABLE `ficha_medicamento` (
  `fimedi_id` int(11) NOT NULL,
  `fimedi_nombre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fimedi_cantidad` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `ficha_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `ficha_medicamento`
--

INSERT INTO `ficha_medicamento` (`fimedi_id`, `fimedi_nombre`, `fimedi_cantidad`, `ficha_id`) VALUES
(1, 'MEDICAMENTO A', '12', NULL),
(2, 'MEDICAMENTO A', '12', NULL),
(3, 'MEDICAMENTO A', '12', 1),
(4, 'MEDICAMENTO B', '1', 2),
(5, 'IBUPROFENO', '10', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `paciente_id` int(11) NOT NULL,
  `paciente_dpi` char(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_nombre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_apellido` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_celular` char(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `paciente_fnacimiento` date DEFAULT NULL,
  `paciente_direccion` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`paciente_id`, `paciente_dpi`, `paciente_nombre`, `paciente_apellido`, `paciente_celular`, `paciente_fnacimiento`, `paciente_direccion`) VALUES
(1, '76216924123444', 'AINHOA', 'RODRIGUEZ TORRES', '912610973', '1995-07-04', 'CASITA'),
(2, '45646456546546', 'IRENE', 'TORRES CHUQUI', '95545445', '1980-01-04', 'PERU'),
(3, '15252454587777', 'PEDRO ', 'YOC XOOM', '54856896', '1979-06-14', 'SAN JOSE '),
(4, '5457875454878', 'MARIA', 'JOSE PEX', '52369854', '1985-01-25', 'SAN JOSE LA MAQUINA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_salud`
--

CREATE TABLE `personal_salud` (
  `personal_salud_id` int(11) NOT NULL,
  `personal_salud_dpi` char(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `personal_salud_nombre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `personal_salud_apellido` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `personal_salud_celular` char(14) COLLATE utf8_spanish_ci DEFAULT NULL,
  `personal_salud_fnacimiento` date DEFAULT NULL,
  `personal_salud_direccion` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `especialidad_id` int(11) DEFAULT NULL,
  `personal_salud_tipo` enum('ENFERMERO(A)','MEDICO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `personal_salud`
--

INSERT INTO `personal_salud` (`personal_salud_id`, `personal_salud_dpi`, `personal_salud_nombre`, `personal_salud_apellido`, `personal_salud_celular`, `personal_salud_fnacimiento`, `personal_salud_direccion`, `especialidad_id`, `personal_salud_tipo`, `usuario_id`) VALUES
(1, '12345678912344', 'JUANA', 'RODRIGUEZ TORRES', '1232131', '1995-03-22', 'ASDASD', NULL, 'ENFERMERO(A)', 3),
(2, '54654654654546', 'ROBERTO', 'PEREZ PERES', '912610973', '1995-09-04', 'ADAS', 2, 'MEDICO', 4),
(3, '762169241234', 'LUIYI ENRIQUE', 'RODRIGUEZ TORRES', '912610973', '1995-01-07', 'GUATEMALA', 1, 'MEDICO', 5),
(4, '54785478787875', 'JUAN MARIA', 'JUAREZ PEX', '45968756', '1998-10-23', 'ENFERMERA ', NULL, 'ENFERMERO(A)', 6),
(5, '65989854578786', 'DAVID JOSE', 'YOX PEREZ', '54896352', '2022-10-18', 'SAMAYAC', 1, 'MEDICO', 7),
(6, '54878878998768', 'MARIO DAVID', 'PEREZ JOSE', '54896897', '1993-06-09', 'NUEVA SAN CARLOS ', 3, 'MEDICO', 8),
(7, '25545786746579', 'DAVID JOSE', 'PEX POOL', '58963458', '1985-05-08', 'SAN JOSé LA MAQUINA', 3, 'MEDICO', 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud`
--

CREATE TABLE `solicitud` (
  `solicitud_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `especialidad_id` int(11) DEFAULT NULL,
  `medico_id` int(11) DEFAULT NULL,
  `enfermero_id` int(11) DEFAULT NULL,
  `solicitud_motivo` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `solicitud_horario` datetime DEFAULT NULL,
  `paciente_id` int(11) DEFAULT NULL,
  `solicitud_fregistro` date DEFAULT NULL,
  `solicitud_estatus` enum('PENDIENTE','ATENDIDO') COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `solicitud`
--

INSERT INTO `solicitud` (`solicitud_id`, `usuario_id`, `especialidad_id`, `medico_id`, `enfermero_id`, `solicitud_motivo`, `solicitud_horario`, `paciente_id`, `solicitud_fregistro`, `solicitud_estatus`) VALUES
(1, 1, 2, 2, 1, 'SADASDXX', '2022-10-15 12:45:00', 1, '2022-10-15', 'ATENDIDO'),
(2, 1, 2, 2, 1, 'SDASDASDADADSSA', '2022-10-15 20:36:00', 2, '2022-10-15', 'ATENDIDO'),
(3, 1, 1, 3, 1, 'DOLOR DE CABEZA', '2022-10-20 16:13:00', 3, '2022-10-22', 'PENDIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `usu_id` int(11) NOT NULL,
  `usu_nombre` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_usuario` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_contrasena` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_rol` enum('ADMINISTRADOR','MEDICO GENERAL','MEDICO','ENFERMERO(A)') COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_status` enum('ACTIVO','INACTIVO') COLLATE utf8_spanish_ci DEFAULT NULL,
  `usu_email` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci ROW_FORMAT=DYNAMIC;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`usu_id`, `usu_nombre`, `usu_usuario`, `usu_contrasena`, `usu_rol`, `usu_status`, `usu_email`) VALUES
(1, 'Luis Francisco Gomez', 'ADMIN', '$2y$10$OdYL8sjQnRrbE8whYkIqtePXUvwp..ZboquH9PktibC4ukwh.54Fm', 'ADMINISTRADOR', 'ACTIVO', 'lert.07.04@gmail.com'),
(3, 'AINHOA RODRIGUEZ TORRES', '12345678912344', '$2y$12$iUHpCxx5kPu1NfsZVZ1Reu4p6NjSXUffCgYQZto35aKDgNQcKXJYi', 'ENFERMERO(A)', 'ACTIVO', NULL),
(4, 'Daniel', '54654654654546', '$2y$12$0Vbse7Wdg4smrwAUpY.o5O/SHugJxjMaXY2BacGEDwbSI.gxUh7L2', 'MEDICO', 'ACTIVO', NULL),
(5, 'MARIO JOSE RODRIGUEZ TORRES', '762169241234', '$2y$12$UtyGhPYXTc7tKkysHYQnqu/OPsY9TQZePVn.ujurR.OoJMDddL7Z6', 'MEDICO', 'INACTIVO', NULL),
(6, 'JUAN MARIA JUAREZ PEX', '54785478787875', '$2y$12$oSXRoNRFBG2bYjep1PbtJeYmqOg9u8elxiLlJ553o2QB97CJIRICS', 'ENFERMERO(A)', 'ACTIVO', NULL),
(7, 'DAVID JOSE YOX PEREZ', '65989854578786', '$2y$12$kc65xHJpTkJ7EGoHm..UtOTuSsS13vVsUCda8SeCJbJNJ2gFr.UxW', 'MEDICO', 'ACTIVO', NULL),
(8, 'MARIO DAVID PEREZ JOSE', '54878878998768', '$2y$12$KbHKU1hBhqx7luoIktp5E.Lla9ww55xBTgoTUpHVA1qfemm.iNFuW', 'MEDICO', 'ACTIVO', NULL),
(9, 'DAVID JOSE PEX POOL', '25545786746579', '$2y$12$MSoby6/5Y3.5a.M5639LjuDJpeecdtY9fCDtnS68WnZIJ9HDdf8r2', 'MEDICO', 'ACTIVO', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `caja`
--
ALTER TABLE `caja`
  ADD PRIMARY KEY (`caja_id`) USING BTREE,
  ADD KEY `usuario_id` (`usuario_id`) USING BTREE;

--
-- Indices de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  ADD PRIMARY KEY (`especialidad_id`) USING BTREE;

--
-- Indices de la tabla `examen`
--
ALTER TABLE `examen`
  ADD PRIMARY KEY (`examen_id`) USING BTREE;

--
-- Indices de la tabla `examen_ficha`
--
ALTER TABLE `examen_ficha`
  ADD PRIMARY KEY (`exaficha_id`) USING BTREE,
  ADD KEY `ficha_id` (`ficha_id`) USING BTREE,
  ADD KEY `examen_id` (`examen_id`) USING BTREE;

--
-- Indices de la tabla `ficha_medica`
--
ALTER TABLE `ficha_medica`
  ADD PRIMARY KEY (`ficha_id`) USING BTREE,
  ADD KEY `solicitud_id` (`solicitud_id`) USING BTREE,
  ADD KEY `usu_id` (`usu_id`) USING BTREE;

--
-- Indices de la tabla `ficha_medicamento`
--
ALTER TABLE `ficha_medicamento`
  ADD PRIMARY KEY (`fimedi_id`) USING BTREE;

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`paciente_id`) USING BTREE;

--
-- Indices de la tabla `personal_salud`
--
ALTER TABLE `personal_salud`
  ADD PRIMARY KEY (`personal_salud_id`) USING BTREE,
  ADD KEY `especialidad_id` (`especialidad_id`) USING BTREE,
  ADD KEY `usuario_id` (`usuario_id`) USING BTREE;

--
-- Indices de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD PRIMARY KEY (`solicitud_id`) USING BTREE,
  ADD KEY `usuario_id` (`usuario_id`) USING BTREE,
  ADD KEY `medico_id` (`medico_id`) USING BTREE,
  ADD KEY `enfermero_id` (`enfermero_id`) USING BTREE,
  ADD KEY `paciente_id` (`paciente_id`) USING BTREE,
  ADD KEY `especialidad_id` (`especialidad_id`) USING BTREE;

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usu_id`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `caja`
--
ALTER TABLE `caja`
  MODIFY `caja_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `especialidad_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `examen`
--
ALTER TABLE `examen`
  MODIFY `examen_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `examen_ficha`
--
ALTER TABLE `examen_ficha`
  MODIFY `exaficha_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ficha_medica`
--
ALTER TABLE `ficha_medica`
  MODIFY `ficha_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ficha_medicamento`
--
ALTER TABLE `ficha_medicamento`
  MODIFY `fimedi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `paciente_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `personal_salud`
--
ALTER TABLE `personal_salud`
  MODIFY `personal_salud_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  MODIFY `solicitud_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `caja`
--
ALTER TABLE `caja`
  ADD CONSTRAINT `caja_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usu_id`);

--
-- Filtros para la tabla `examen_ficha`
--
ALTER TABLE `examen_ficha`
  ADD CONSTRAINT `examen_ficha_ibfk_1` FOREIGN KEY (`ficha_id`) REFERENCES `ficha_medica` (`ficha_id`),
  ADD CONSTRAINT `examen_ficha_ibfk_2` FOREIGN KEY (`examen_id`) REFERENCES `examen` (`examen_id`);

--
-- Filtros para la tabla `ficha_medica`
--
ALTER TABLE `ficha_medica`
  ADD CONSTRAINT `ficha_medica_ibfk_1` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitud` (`solicitud_id`),
  ADD CONSTRAINT `ficha_medica_ibfk_2` FOREIGN KEY (`usu_id`) REFERENCES `usuario` (`usu_id`);

--
-- Filtros para la tabla `personal_salud`
--
ALTER TABLE `personal_salud`
  ADD CONSTRAINT `personal_salud_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`especialidad_id`),
  ADD CONSTRAINT `personal_salud_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usu_id`);

--
-- Filtros para la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD CONSTRAINT `solicitud_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`usu_id`),
  ADD CONSTRAINT `solicitud_ibfk_2` FOREIGN KEY (`medico_id`) REFERENCES `personal_salud` (`personal_salud_id`),
  ADD CONSTRAINT `solicitud_ibfk_3` FOREIGN KEY (`enfermero_id`) REFERENCES `personal_salud` (`personal_salud_id`),
  ADD CONSTRAINT `solicitud_ibfk_4` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`),
  ADD CONSTRAINT `solicitud_ibfk_5` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidad` (`especialidad_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
