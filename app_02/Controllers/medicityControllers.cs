using app_02.DTO;
using app2.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace app2.Controllers
{
    [Route("api/medicity/distribuida")]
    [ApiController]
    public class medicityControllers : ControllerBase
    {
        private readonly AppDbContext _context;

        public medicityControllers(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("general")]
        public async Task<IActionResult> GetProductosView()
        {
            var productos = await _context.ConsultaGeneral.ToListAsync();

            return Ok(productos);
        }


        [HttpGet("doctor")]
        public async Task<IActionResult> GetDoctorView()
        {
            var doctor = await _context.consultaDoctor.ToListAsync();

            return Ok(doctor);
        }

        [HttpGet("paciente")]
        public async Task<IActionResult> GetPacienteView()
        {
            var paciente = await _context.consultaPaciente.ToListAsync();

            return Ok(paciente);
        }

        [HttpGet("diagnostico")]
        public async Task<IActionResult> GetDiagnosticoView()
        {
            var diagnostico = await _context.consultarDiagnosticos.ToListAsync();

            return Ok(diagnostico);
        }

        [HttpGet("citasMedicas")]
        public async Task<IActionResult> GetCitaMedicaView()
        {
            var cita = await _context.consultarCitas.ToListAsync();

            return Ok(cita);
        }





        [HttpPost("sp_doctor")]
        public async Task<IActionResult> CrearDoctor(DoctorCrearDto doctor)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_InsertarDoctor
                    @NOMBRE = {doctor.Nombre},
                    @ID_ESPECIALIDAD = {doctor.IdEspecialidad},
                    @ID_CIUDAD = {doctor.IdCiudad}
            ");

                return Ok(new
                {
                    mensaje = "Doctor registrado correctamente"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }



        [HttpPut("cita/{id}")]
        public async Task<IActionResult> ActualizarCita(
        int id, UpdateCItasDto cita)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_ActualizarCitaMedica
                    @ID = {id},
                    @ID_PACIENTE = {cita.IdPaciente},
                    @ID_DOCTOR = {cita.IdDoctor},
                    @FECHAHORA = {cita.FechaHora}
            ");

                return Ok(new
                {
                    mensaje = "Cita médica actualizada correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }


         [HttpPut("diagnostico/{id}")]
        public async Task<IActionResult> ActualizarDiagnostico(
        int id, updateDiagnosticoDto diagnostico)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_ActualizarDiagnostico
                    @ID = {id},      
                    @ID_CITA = {diagnostico.id_cita},
                    @NOMBRE = {diagnostico.nombre},
                    @DESCRIPCION = {diagnostico.descripcion},
                    @TRATAMIENTO = {diagnostico.tratamiento}
            ");

                return Ok(new
                {
                    mensaje = "Diagnostico actualizado correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }



        [HttpPut("paciente/{id}")]
        public async Task<IActionResult> ActualizarPaciente(
        int id, updatePacienteDto paciente)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_updatePaciente
                    @ID = {id},
                    @NOMBRE = {paciente.nombre},
                    @FECHA_NACIMIENTO = {paciente.fecha_nacimiento},
                    @DIRECCION = {paciente.direccion},
                    @ID_CIUDAD = {paciente.id_ciudad}
            ");

                return Ok(new
                {
                    mensaje = "Paciente actualizado correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }





    }



}


/*[HttpPost("sp")]
public async Task<IActionResult> CreateProductoSP(Product product)
{
    await _context.Database.ExecuteSqlInterpolatedAsync(
        $"EXEC products_insert_sp @names={product.Names}, @price={product.Price}, @stock={product.Stock}"
    );

    return Ok("Producto creado correctamente");
}*/





