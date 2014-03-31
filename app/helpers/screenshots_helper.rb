module ScreenshotsHelper
  def screenshot_popover_content(screenshot)
    if screenshot.session && screenshot.session.race && screenshot.session.race.fia?
      "Enter laps, lap times and sector times here. Syntax highlighting will help you with data entry - Black indicates a formatting problem. Red indicates a lap / sector time calculation error. Blue indicates that everything appears to be correct."
    else
      "This is the text that Tesseract returns from the screenshot. Black indicates a formatting problem. Red indicates a lap / sector time calculation error. Blue indicates that everything appears to be correct."
    end
  end
end
