using System.Windows.Input;
using Reserve_iT.Essentials;
using Reserve_iT.View;

namespace Reserve_iT.ViewModel
{
	public class MainWindowViewModel : NotifyObject
	{
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

		public ICommand ShowBookingSearchViewCommand { get; }

		public ICommand GoToDashboardCommand { get; }

		public MainWindowViewModel()
		{
			// DashboardView to BookingSearchview
			CurrentView = new DashboardView();
			ShowBookingSearchViewCommand = new RelayCommand(ShowBookingSearchView);

			// BookingSearchView to DashboardView
			CurrentView = new DashboardView();
			GoToDashboardCommand = new RelayCommand(GoToDashboard);
		}

		private void ShowBookingSearchView()
		{
			CurrentView = new BookingSearchView();
		}

		private void GoToDashboard()
		{
			CurrentView = new DashboardView();
		}

	}
}
