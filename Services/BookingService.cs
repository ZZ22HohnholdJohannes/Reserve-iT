using System;
using System.Data;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace Reserve_iT.Services
{
  public class BookingService
  {
    private readonly string _connectionString = "Server=localhost;Database=reserve_it;User=root;Password=;";

    public bool CheckAvailability(DateTime startDate, DateTime endDate, int kategorieId, int artId)
    {
      using (var connection = new MySqlConnection(_connectionString))
      {
        connection.Open();

        using (var command = new MySqlCommand("checkAvailability", connection))
        {
          command.CommandType = CommandType.StoredProcedure;
          command.Parameters.AddWithValue("@startDate", startDate);
          command.Parameters.AddWithValue("@endDate", endDate);
          command.Parameters.AddWithValue("@kategorieZimmer", kategorieId);
          command.Parameters.AddWithValue("@artZimmer", artId);

          using (var reader = command.ExecuteReader())
          {
            return reader.HasRows; // Gibt zurück, ob ein passendes Zimmer gefunden wurde
          }
        }
      }
    }
  }
}
