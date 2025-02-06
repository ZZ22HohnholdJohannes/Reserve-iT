using System.Windows.Input;
using Reserve_iT.Essentials;
using Reserve_iT.View;

namespace Reserve_iT.ViewModel
{
	public class DashboardViewModel : NotifyObject
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
					OnPropertyChanged(nameof(CurrentView));
				}
			}
		}

		public ICommand ShowBookingSearchViewCommand { get; }

		public DashboardViewModel()
		{
			ShowBookingSearchViewCommand = new RelayCommand(ShowBookingSearchView);
			CurrentView = new DashboardView();
		}

		private void ShowBookingSearchView()
		{
			CurrentView = new BookingSearchView();
		}
	}
}
