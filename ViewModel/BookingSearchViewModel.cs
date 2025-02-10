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
      CreateCommands();
    }

    private DateTime _startDate = DateTime.Today;
    public DateTime StartDate
    {
      get => _startDate;
      set => Set(_startDate);
    }

    private DateTime _endDate = DateTime.Today.AddDays(1);
    public DateTime EndDate
    {
      get => _endDate;
      set => Set(_endDate);
    }

    private int _selectedCategory;
    public int SelectedCategory
    {
      get => _selectedCategory;
      set => Set(_selectedCategory);
    }

    private int _selectedRoomType;
    public int SelectedRoomType
    {
      get => _selectedRoomType;
      set => Set(_selectedRoomType);
    }
    private void CreateCommands()
    {
      CheckAvailabilityCommand = new RelayCommand(CheckAvailability);
    }

    public ICommand CheckAvailabilityCommand { get; private set; }

    private void CheckAvailability()
    {
      bool isAvailable = _bookingService.CheckAvailability(StartDate, EndDate, SelectedCategory, SelectedRoomType);

      if (isAvailable)
      {
        // Weiterleitung zur nächsten View oder UI-Feedback
        Debug.WriteLine("Zimmer verfügbar!");
      }
      else
      {
        Debug.WriteLine("Kein Zimmer verfügbar.");
      }
    }
  }
}
