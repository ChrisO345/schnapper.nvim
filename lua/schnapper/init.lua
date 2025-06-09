local group = vim.api.nvim_create_augroup("schnapper", {})
local namespace = vim.api.nvim_create_namespace("schnapper")

local M = {}

M.opts = {
  enabled = true,
  img_dir = vim.fn.stdpath("cache") .. "/schnapper",
  video_dir = vim.fn.stdpath("cache") .. "/schnapper/videos",
  img_format = "png",   -- Anything supported by ffmpeg, e.g. "png", "jpg", "webp"
  video_format = "mp4", -- Anything supported by ffmpeg, e.g. "mp4", "mkv", "avi"
  video_fps = 30,       -- Frames per second for video recording
  display = "",         -- Display to capture, e.g. ":0.0" for Linux, or leave empty for default
  os = "auto",          -- "win", "linux", "mac", "auto"
}

M.setup = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  if not M.opts.enabled then
    return
  end

  -- Check that ffmpeg is installed
  local ffmpeg_path = vim.fn.exepath("ffmpeg")
  if ffmpeg_path == "" then
    vim.api.nvim_err_writeln("ffmpeg is not installed or not found in PATH.")
    return
  end

  if M.opts.os == "auto" then
    ---@diagnostic disable-next-line: undefined-field
    local system = vim.loop.os_uname().sysname:lower()
    if system:find("linux") then
      if M.opts.display == "" then
        M.opts.display = os.getenv("DISPLAY") or ":0.0"
      end
      M.opts.os = "linux"
    elseif system:find("windows") then
      if M.opts.display == "" then
        M.opts.display = "desktop" -- Default for Windows
      end
      M.opts.os = "win"
    elseif system:find("darwin") then
      if M.opts.display == "" then
        M.opts.display = "1" -- Default for macOS, usually device 1 is the main screen
      end
      M.opts.os = "mac"
    else
      error("Unsupported OS for Schnapper: " .. system)
    end
  end

  local usercmd = vim.api.nvim_create_user_command
  usercmd("SchnapperCapture", M.capture, {})
  usercmd("SchnapperSelection", M.capture_selection, {})
  usercmd("SchnapperRecord", M.start_recording, {})
  usercmd("SchnapperStop", M.stop_recording, {})
end

M.capture = function()
  if not M.opts.enabled then
    return
  end

  local img_dir = M.opts.img_dir
  vim.fn.mkdir(img_dir, "p")
  local timestamp = os.date("%Y%m%d_%H%M%S")
  local img_path = img_dir .. "/screenshot_" .. timestamp .. ".png"

  local display = M.opts.display

  local cmd
  if M.opts.os == "win" then
    -- Windows: gdigrab for full desktop
    cmd = string.format(
      'ffmpeg -y -f gdigrab -framerate 1 -i %s -vframes 1 "%s"', display, img_path)
  elseif M.opts.os == "mac" then
    -- macOS: avfoundation, usually device 1 is main screen
    cmd = string.format(
      'ffmpeg -y -f avfoundation -framerate 1 -i "%s" -vframes 1 "%s"', display, img_path)
  elseif M.opts.os == "linux" then
    -- Linux: x11grab, grab display from $DISPLAY (default :0.0)
    cmd = string.format(
      'ffmpeg -y -f x11grab -video_size $(xdpyinfo | grep dimensions | awk \'{print $2}\') -i %s -vframes 1 "%s"',
      display, img_path)
  else
    vim.api.nvim_err_writeln("Unsupported OS for screenshot capture: " .. tostring(M.opts.os))
    return
  end

  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Error capturing screenshot: " .. result)
    return
  end
  print("Screenshot saved to: " .. img_path)
end

M.capture_selection = function()
  if not M.opts.enabled then
    return
  end

  -- Record using ffmpeg 1fps for 1 frame,
  -- Region based on visual selection
  -- Store the screenshot in the specified directory
  error(":SchnapperSelection is not implemented yet")
end

M.start_recording = function()
  if not M.opts.enabled then
    return
  end

  -- Start recording logic here
  -- Use ffmpeg to start recording the screen or window
  -- Store the recorded video in a specified directory
  error(":ShnapperRecord is not implemented yet")
end

M.stop_recording = function()
  if not M.opts.enabled then
    return
  end

  -- Stop recording logic here
  -- Use ffmpeg to stop the recording
  -- Save the recorded video in a specified directory
  error(":SchnapperStop is not implemented yet")
end

return M
