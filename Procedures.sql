-------Procedures
CREATE OR ALTER PROCEDURE sp_ActualizarDiagnostico
    @ID INT,
    @ID_CITA INT,
    @NOMBRE VARCHAR(50),
    @DESCRIPCION VARCHAR(200),
    @TRATAMIENTO VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la cita
    IF NOT EXISTS (
        SELECT 1
        FROM LS_SITIO_B.MEDICITY_B.DBO.DIAGNOSTICO_SB 
        WHERE ID = @ID
    )
    BEGIN
        RAISERROR('El diagnostico medico no existe.', 16, 1);
        RETURN;
    END;

    -- Validar cita medica en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[CITA_MEDICA_SA]
        WHERE ID = @ID_CITA
    )
    BEGIN
        RAISERROR('La cita medica ingresada no existe.', 16, 1);
        RETURN;
    END;

    -- Actualizar
    UPDATE LS_SITIO_B.MEDICITY_B.DBO.DIAGNOSTICO_SB 
    SET
        ID_CITA = @ID_CITA,
        NOMBRE = @NOMBRE,
        DESCRIPCION = @DESCRIPCION,
        TRATAMIENTO = @TRATAMIENTO
    WHERE ID = @ID;
END;
GO


-------------------------------------------


CREATE OR ALTER PROCEDURE sp_updatePaciente
    @ID INT,
    @NOMBRE VARCHAR(200),
    @FECHA_NACIMIENTO DATETIME,
    @DIRECCION VARCHAR(200),
    @ID_CIUDAD INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista el paciente
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.PACIENTE_SA
        WHERE ID = @ID
    )
    BEGIN
        RAISERROR('El paciente no existe.', 16, 1);
        RETURN;
    END;


    --- Validar nombre y direccion no nulas

  IF @NOMBRE IS NULL OR LTRIM(RTRIM(@NOMBRE)) = '' 
   OR @DIRECCION IS NULL OR LTRIM(RTRIM(@DIRECCION)) = ''
BEGIN
    RAISERROR('El nombre y la dirección no pueden ser nulos ni estar vacíos.', 16, 1);
    RETURN;
END;


    -- Validar fecha
    IF @FECHA_NACIMIENTO > GETDATE()
    BEGIN
        RAISERROR(
            'La fecha de nacimiento no puede ser mayor a la actual',
            16,
            1
        );
        RETURN;
    END;

    -- Validar paciente en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[CIUDAD_SA]
        WHERE ID = @ID_CIUDAD
    )
    BEGIN
        RAISERROR('La ciudad no existe.', 16, 1);
        RETURN;
    END;

    -- Actualizar
    UPDATE dbo.PACIENTE_SA
    SET
        NOMBRE = @NOMBRE,
        FECHA_NACIMIENTO = @FECHA_NACIMIENTO,
        DIRECCION = @DIRECCION,
        ID_CIUDAD = @ID_CIUDAD
    WHERE ID = @ID;
END;
GO

-------------------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_ActualizarCitaMedica
    @ID INT,
    @ID_PACIENTE INT,
    @ID_DOCTOR INT,
    @FECHAHORA DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la cita
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CITA_MEDICA_SA
        WHERE ID = @ID
    )
    BEGIN
        RAISERROR('La cita médica no existe.', 16, 1);
        RETURN;
    END;

    -- Validar fecha
    IF @FECHAHORA < GETDATE()
    BEGIN
        RAISERROR(
            'La fecha y hora de la cita no puede ser anterior a la fecha actual.',
            16,
            1
        );
        RETURN;
    END;

    -- Validar paciente en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[PACIENTE_SA]
        WHERE ID = @ID_PACIENTE
    )
    BEGIN
        RAISERROR('El paciente ingresado no existe.', 16, 1);
        RETURN;
    END;

    -- Validar doctor en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [LS_SITIO_B].[MEDICITY_B].[dbo].[DOCTOR_SB]
        WHERE ID = @ID_DOCTOR
    )
    BEGIN
        RAISERROR('El doctor ingresado no existe.', 16, 1);
        RETURN;
    END;

    -- Actualizar
    UPDATE dbo.CITA_MEDICA_SA
    SET
        ID_PACIENTE = @ID_PACIENTE,
        ID_DOCTOR = @ID_DOCTOR,
        FECHAHORA = @FECHAHORA
    WHERE ID = @ID;
END;
GO

--------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarDoctor
    @NOMBRE VARCHAR(200),
    @ID_ESPECIALIDAD INT,
    @ID_CIUDAD INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la ciudad local
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CIUDAD_SA
        WHERE ID = @ID_CIUDAD
    )
    BEGIN
        RAISERROR('La ciudad ingresada no existe.', 16, 1);
        RETURN;
    END;

    -- Validar que exista la especialidad en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [LS_SITIO_B].[MEDICITY_B].[dbo].[ESPECIALIDAD_SB]
        WHERE ID = @ID_ESPECIALIDAD
    )
    BEGIN
        RAISERROR('La especialidad ingresada no existe.', 16, 1);
        RETURN;
    END;

    -- AQUÍ FALTABA EL INSERT INTO Y LA TABLA
    INSERT INTO [LS_SITIO_B].[MEDICITY_B].[dbo].[DOCTOR_SB] (
        NOMBRE,
        ID_ESPECIALIDAD,
        ID_CIUDAD
    )
    VALUES (
        @NOMBRE,
        @ID_ESPECIALIDAD,
        @ID_CIUDAD
    );

    SELECT 'Doctor registrado correctamente' AS MENSAJE;
END;
GO