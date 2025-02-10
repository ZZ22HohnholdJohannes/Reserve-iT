using System.Windows.Input;
using Reserve_iT.Essentials;
using Reserve_iT.View;

namespace Reserve_iT.ViewModel
{
  public class MainWindowViewModel : NotifyObject
  {
    #region Properties
    private object _currentView;
    public object CurrentView
    {
      get => _currentView;
      set
      {
        if (_currentView != value)
        {
          _currentView = value;
          OnPropertyChanged();
        }
      }
    }
    public bool IsAdminLoggedIn
    {
      get => Get<bool>(nameof(IsAdminLoggedIn));
      set => Set(value, nameof(IsAdminLoggedIn));
    }

    public string AdminPassword
    {
      get => Get<string>(nameof(AdminPassword));
      set => Set(value, nameof(AdminPassword));
    }

    #endregion

    #region Commands
    public ICommand ShowBookingSearchViewCommand { get; }
    public ICommand GoToDashboardCommand { get; }
    public ICommand LoginCommand { get; }
    #endregion

    #region Constructor
    public MainWindowViewModel()
    {
      // Standardmäßig ist der Administrator-Status deaktiviert
      IsAdminLoggedIn = false;

      // Setze initial die DashboardView als Startansicht
      CurrentView = new DashboardView();

      // Initialisiere die Commands
      ShowBookingSearchViewCommand = new RelayCommand(ShowBookingSearchView);
      GoToDashboardCommand = new RelayCommand(GoToDashboard);
      LoginCommand = new RelayCommand(Login);
    }
    #endregion

    #region Methods
    private void ShowBookingSearchView()
    {
      CurrentView = new BookingSearchView();
    }

    private void GoToDashboard()
    {
      CurrentView = new DashboardView();
    }

    private void Login()
    {
      if (AdminPassword == "Administrator")
      {
        IsAdminLoggedIn = true;
      }
      else
      {
        IsAdminLoggedIn = false;
      }
    }
    #endregion
  }
}
