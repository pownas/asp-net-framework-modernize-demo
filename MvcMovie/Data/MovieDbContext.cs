using Microsoft.EntityFrameworkCore;
using MvcMovie.Models;

namespace MvcMovie.Data
{
    /// <summary>
    /// Application data DbContext using EF Core
    /// Migrated from: MvcMovie\Models\Movie.cs (MovieDBContext)
    /// 
    /// This context handles the Movie entity and related data access.
    /// The connection string is configured in Program.cs via AddDbContext.
    /// </summary>
    public class MovieDbContext : DbContext
    {
        public MovieDbContext(DbContextOptions<MovieDbContext> options)
            : base(options)
        {
        }

        public DbSet<Movie> Movies { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure Movie entity
            modelBuilder.Entity<Movie>(entity =>
            {
                entity.HasKey(e => e.ID);

                entity.Property(e => e.Title)
                    .HasMaxLength(60)
                    .IsRequired();

                entity.Property(e => e.Genre)
                    .HasMaxLength(30)
                    .IsRequired();

                entity.Property(e => e.Rating)
                    .HasMaxLength(5);

                // Configure decimal precision for Price
                // EF6 default was decimal(18,2); explicit configuration required in EF Core
                entity.Property(e => e.Price)
                    .HasPrecision(18, 2)
                    .IsRequired();

                entity.Property(e => e.ReleaseDate)
                    .IsRequired();
            });

            // Seed initial movie data (migrated from Configuration.cs)
            // Using HasData() provides compile-time seed data baked into migrations
            modelBuilder.Entity<Movie>().HasData(
                new Movie
                {
                    ID = 1,
                    Title = "When Harry Met Sally",
                    ReleaseDate = new DateTime(1989, 1, 11),
                    Genre = "Romantic Comedy",
                    Rating = "PG",
                    Price = 7.99m
                },
                new Movie
                {
                    ID = 2,
                    Title = "Ghostbusters",
                    ReleaseDate = new DateTime(1984, 3, 13),
                    Genre = "Comedy",
                    Rating = "PG",
                    Price = 8.99m
                },
                new Movie
                {
                    ID = 3,
                    Title = "Ghostbusters 2",
                    ReleaseDate = new DateTime(1986, 2, 23),
                    Genre = "Comedy",
                    Rating = "PG",
                    Price = 9.99m
                },
                new Movie
                {
                    ID = 4,
                    Title = "Rio Bravo",
                    ReleaseDate = new DateTime(1959, 4, 15),
                    Genre = "Western",
                    Rating = "Not Rated",
                    Price = 3.99m
                }
            );
        }
    }
}
