namespace app_02.DTO;

public class updateDiagnosticoDto
{
    
    public int id_cita { get; set; }
    public string nombre { get; set; } = null!;
    public string descripcion { get; set; }
    public string tratamiento { get; set; }
}
