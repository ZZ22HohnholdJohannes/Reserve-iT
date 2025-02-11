using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Reserve_iT.Services;
using Reserve_iT.Essentials;
using System.Diagnostics;

namespace Reserve_iT.ViewModel
{
  public class BookingSearchViewModel : NotifyObject
  {
    private readonly BookingService _bookingService;

    public BookingSearchViewModel()
    {
      _bookingService = new BookingService();
      StartDate = DateTime.Now;
      EndDate = DateTime.Now.AddDays(1);
      CreateCommands();
    }

    public DateTime StartDate
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public DateTime EndDate
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public bool Standard
    {
      get => Get<bool>();
      set => Set(value);
    }

    public bool Premium
    {
      get => Get<bool>();
      set => Set(value);
    }

    public bool Luxury
    {
      get => Get<bool>();
      set => Set(value);
    }

    public bool SingleRoom
    {
      get => Get<bool>();
      set => Set(value);
    }

    public bool DoubleRoom
    {
      get => Get<bool>();
      set => Set(value);
    }

    private void CreateCommands()
    {
      CheckAvailabilityCommand = new RelayCommand(CheckAvailability);
    }

    public ICommand CheckAvailabilityCommand { get; private set; }

    private void CheckAvailability()
    {
      if (StartDate >= EndDate)
      {
        Debug.WriteLine("Das Anreisedatum muss vor dem Abreisedatum liegen.");
        return;
      }

      // 2. Überprüfen, ob eine Zimmerkategorie ausgewählt wurde (Standard, Premium oder Luxus)
      if (!(Standard || Premium || Luxury))
      {
        Debug.WriteLine("Bitte wählen Sie eine Zimmerkategorie (Standard, Premium oder Luxus).");
        return;
      }

      // 3. Überprüfen, ob eine Zimmerart ausgewählt wurde (Einzelzimmer oder Doppelzimmer)
      if (!(SingleRoom || DoubleRoom))
      {
        Debug.WriteLine("Bitte wählen Sie eine Zimmerart (Einzelzimmer oder Doppelzimmer).");
        return;
      }

      bool isAvailable = _bookingService.CheckAvailability(StartDate, EndDate, Standard, Premium, Luxury, SingleRoom, DoubleRoom);

      if (isAvailable)
      {
        Debug.WriteLine("Zimmer verfügbar!");
      }
      else
      {
        Debug.WriteLine("Kein Zimmer verfügbar.");
      }
    }
  }
}
