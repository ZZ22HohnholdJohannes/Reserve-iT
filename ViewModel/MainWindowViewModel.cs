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
					OnPropertyChanged(nameof(CurrentView));
				}
			}
		}

		public ICommand ShowBookingViewCommand { get; }

		public MainWindowViewModel()
		{
			ShowBookingViewCommand = new RelayCommand(ShowBookingView);
			CurrentView = new MainWindowView();
		}

		private void ShowBookingView()
		{
			CurrentView = new BookingView();
		}
	}
}
