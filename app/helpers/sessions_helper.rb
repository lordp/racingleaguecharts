module SessionsHelper
  def screenshot_class(screenshot)
    screenshot.confirmed ? "tick" : "cross"
  end
end
