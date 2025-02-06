using System.Windows.Input;
using Reserve_iT.Essentials;
using Reserve_iT.View;

namespace Reserve_iT.ViewModel
{
	public class ShellViewModel : NotifyObject
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

		public ShellViewModel()
		{
			// Startansicht setzen
			CurrentView = new DashboardView();
			ShowBookingSearchViewCommand = new RelayCommand(ShowBookingSearchView);
		}

		private void ShowBookingSearchView()
		{
			CurrentView = new BookingSearchView();
		}

	}
}
