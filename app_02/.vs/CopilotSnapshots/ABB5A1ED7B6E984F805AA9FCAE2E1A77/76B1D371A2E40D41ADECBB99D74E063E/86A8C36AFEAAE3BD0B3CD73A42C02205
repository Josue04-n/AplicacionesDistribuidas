using app_02.DTO;
using app_02.Views;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace app2.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(
        DbContextOptions<AppDbContext> options)
        : base(options)
        {

        }
        public DbSet<ConsultaGeneral> ConsultaGeneral { get; set; }
        public DbSet<consultaDoctor> consultaDoctor { get; set; }
        public DbSet<consultaPaciente> consultaPaciente { get; set; }
        public DbSet<consultarDiagnostico> consultarDiagnosticos{ get; set; }
        public DbSet<consultaVistaCitaMedica> consultarCitas { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ConsultaGeneral>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("consulta_general");
            });

            modelBuilder.Entity<consultaDoctor>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_doctores");
            });

            modelBuilder.Entity<consultaPaciente>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_paciente");
            });

            modelBuilder.Entity<consultarDiagnostico>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_diagnostico");
            });

            modelBuilder.Entity<consultaVistaCitaMedica>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vista_cita_medica");
            });
        }

       

      
    }
}
