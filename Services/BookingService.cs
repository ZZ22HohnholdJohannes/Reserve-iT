using System;
using System.Data;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace Reserve_iT.Services
{
  public class BookingService
  {
    private readonly string _connectionString = "Server=localhost;Database=reserve_it;User=root;Password=;";

    public bool CheckAvailability(DateTime startDate, DateTime endDate, bool standard, bool premium, bool luxury, bool singleRoom, bool doubleRoom)
    {
      int category = -1;
      if (standard)
        category = 1;
      else if (premium)
        category = 2;
      else if (luxury)
        category = 3;

      int type = -1;
      if (singleRoom)
        type = 1;
      else if (doubleRoom)
        type = 2;

      DataTable dt = new DataTable();
      using (var connection = new MySqlConnection(_connectionString))
      {
        connection.Open();

        using (var command = new MySqlCommand("checkAvailability", connection))
        {
          command.CommandType = CommandType.StoredProcedure;
          command.Parameters.AddWithValue("startDate", startDate);
          command.Parameters.AddWithValue("endDate", endDate);
          command.Parameters.AddWithValue("kategorieZimmer", category);
          command.Parameters.AddWithValue("artZimmer", type);

          using (MySqlDataAdapter reader = new MySqlDataAdapter(command))
          {
            reader.Fill(dt);
            if (dt.Rows.Count > 0)
            {
              return true;
            }
            else return false;
          }
        }
      }
    }
  }
}
