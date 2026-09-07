namespace app_02.Views;

public class consultarDiagnostico
{
    public string nombre_diagnostico { get; set; } = null!;
    public string descripcion { get; set; } = null!;
    public string tratamiento { get; set; } = null!;
}


/*
 CREATE VIEW vista_diagnostico AS
SELECT 
    D.NOMBRE AS NOMBRE_DIAGNOSTICO, 
    D.DESCRIPCION AS DESCRIPCION,
    D.TRATAMIENTO AS TRATAMIENTO
FROM LS_SITIO_B.MEDICITY_B.DBO.DIAGNOSTICO_SB  D

*/
