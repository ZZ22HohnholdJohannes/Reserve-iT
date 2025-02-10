using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace Reserve_iT.Converters
{
  public class BoolToVisibilityConverter : IValueConverter
  {
    // Wenn der Parameter "invert" übergeben wird, wird das Ergebnis umgekehrt.
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
      bool flag = false;
      if (value is bool)
        flag = (bool)value;

      if (parameter != null && parameter.ToString() == "invert")
        flag = !flag;

      return flag ? Visibility.Visible : Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
      if (value is Visibility vis)
      {
        bool result = (vis == Visibility.Visible);
        if (parameter != null && parameter.ToString() == "invert")
          result = !result;
        return result;
      }
      return false;
    }
  }
}
