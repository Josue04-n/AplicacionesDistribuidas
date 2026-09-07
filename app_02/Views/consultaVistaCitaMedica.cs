namespace app_02.Views;

public class consultaVistaCitaMedica
{
    public string paciente { get; set; } = null!;
    public string doctor { get; set; } = null!;
    public DateTime fechaHora { get; set; }
}


/*
 ALTER VIEW vista_cita_medica AS
SELECT 
    P.NOMBRE AS PACIENTE, 
    D.NOMBRE AS DOCTOR, 
    CM.FECHAHORA
FROM MEDICITY_A.DBO.CITA_MEDICA_SA CM
INNER JOIN MEDICITY_A.DBO.PACIENTE_SA P ON P.ID = CM.ID_PACIENTE
INNER JOIN LS_SITIO_B.MEDICITY_B.DBO.DOCTOR_SB D ON D.ID = CM.ID_DOCTOR;
*/