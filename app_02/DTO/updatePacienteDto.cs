namespace app_02.DTO;

public class updatePacienteDto
{
    public string nombre { get; set; } = null!;
    public DateTime fecha_nacimiento { get; set; }
    public string direccion { get; set; } = null!;
    public int id_ciudad { get; set; }
}
