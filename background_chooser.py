import pythoncom
from win32com.shell import shell, shellcon
import os

def set_wallpaper_per_monitor(monitor_index, image_path):
    # Ensure the path is absolute
    absolute_path = os.path.abspath(image_path)
    
    if not os.path.exists(absolute_path):
        print(f"Error: File {absolute_path} not found.")
        return

    # Initialize the COM libraries for the current thread
    pythoncom.CoInitialize()

    # Create the IDesktopWallpaper object
    # CLSID: {C2CF3110-460E-4fc1-B9D0-8A1C0C9CC4BD}
    wallpaper_manager = shell.CoCreateInstance(
        shellcon.CLSID_DesktopWallpaper, 
        None, 
        pythoncom.CLSCTX_LOCAL_SERVER, 
        shellcon.IID_IDesktopWallpaper
    )

    try:
        # Get the Monitor ID (Hardware Device Path) for the given index
        monitor_id = wallpaper_manager.GetMonitorDevicePathAt(monitor_index)
        
        # Apply the wallpaper to that specific monitor
        wallpaper_manager.SetWallpaper(monitor_id, absolute_path)
        print(f"Successfully set monitor {monitor_index} to {absolute_path}")
        
    except Exception as e:
        print(f"Failed to set wallpaper: {e}")
    finally:
        # Uninitialize COM
        pythoncom.CoUninitialize()

if __name__ == "__main__":
    # Monitor 0 is usually your primary, 1 is your secondary
    set_wallpaper_per_monitor(0, "./pictures/1.jpg")
    set_wallpaper_per_monitor(1, "./pictures/2.jpg")