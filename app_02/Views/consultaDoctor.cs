using Microsoft.AspNetCore.Http.HttpResults;

namespace app_02.Views;

public class consultaDoctor
{
    public string Nombre { get; set; } = null!;
    public string Especialidad { get; set; } = null!;
    public string Ciudad_Doctor { get; set; } = null!;
}


/*ALTER VIEW vista_doctores AS
SELECT
    D.NOMBRE AS NOMBRE,
    E.NOMBRE AS ESPECIALIDAD,
    C.NOMBRE AS CIUDAD_DOCTOR
FROM LS_SITIO_B.MEDICITY_B.DBO.DOCTOR_SB D
INNER JOIN MEDICITY_A.DBO.CIUDAD_SA C ON C.ID = D.ID_CIUDAD
INNER JOIN LS_SITIO_B.MEDICITY_B.DBO.ESPECIALIDAD_SB E ON E.ID = D.ID_ESPECIALIDAD;
*/
