using System.Windows;
using Reserve_iT.View;

namespace Reserve_iT
{
	public partial class App : Application
	{
		private void Application_Startup(object sender, StartupEventArgs e)
		{
			MainView mainWindow = new MainView();
			mainWindow.Show();
		}
	}
}
