namespace app_02.Views;

public class consultaPaciente
{
    public string nombre_paciente { get; set; } = null!;
    public int edad { get; set; }
    public string direccion { get; set; } = null!;
    public string ciudad_paciente { get; set; } = null!;
}

/*
 ALTER VIEW vista_paciente AS
SELECT 
    P.NOMBRE AS NOMBRE_PACIENTE,
    DATEDIFF(YEAR, P.FECHA_NACIMIENTO, GETDATE()) AS EDAD,
    P.DIRECCION AS DIRECCION,
    C.NOMBRE AS CIUDAD_PACIENTE
FROM MEDICITY_A.DBO.PACIENTE_SA P
INNER JOIN MEDICITY_A.DBO.CIUDAD_SA C ON C.ID = P.ID_CIUDAD
*/