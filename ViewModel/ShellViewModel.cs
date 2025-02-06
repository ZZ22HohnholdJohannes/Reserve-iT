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

		public ICommand ShowBookingViewCommand { get; }

		public ShellViewModel()
		{
			// Startansicht setzen
			CurrentView = new MainWindowView();
			ShowBookingViewCommand = new RelayCommand(ShowBookingView);
		}

		private void ShowBookingView()
		{
			CurrentView = new BookingView();
		}

	}
}
