using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Reserve_iT.Essentials
{
	public abstract class NotifyObject : INotifyPropertyChanged
	{
		private readonly Dictionary<string, object> propertyValues;

		protected NotifyObject()
		{
			propertyValues = new Dictionary<string, object>();
		}

		protected virtual void Set<T>(T value, [CallerMemberName] string propertyName = null)
		{
			if (propertyValues.ContainsKey(propertyName))
			{
				// Nur ändern, wenn es eine Änderung gab, oder null ist
				if (propertyValues[propertyName] == null || !propertyValues[propertyName].Equals(value))
				{
					propertyValues[propertyName] = value;
				}
			}
			else
			{
				propertyValues.Add(propertyName, value);
			}
			OnPropertyChanged(propertyName);
		}

		protected T Get<T>([CallerMemberName] string propertyName = null)
		{
			if (propertyValues.TryGetValue(propertyName, out object? value))
			{
				return (T)value;
			}
			return default;
		}

		public event PropertyChangedEventHandler PropertyChanged;

		public virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
		{
			PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
		}
	}
}
