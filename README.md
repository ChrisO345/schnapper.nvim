# schnapper.nvim

# ⚠️Disclaimer
schnapper.nvim is currently in active development. Not all features have been implemented yet, and the API may change. Use at your own discretion and feel free to contribute or report issues.

---

`schnapper.nvim` is a lightweight Neovim plugin that allows you to capture screenshots or record your screen using `ffmpeg`, all directly from within Neovim. Ideal for demos, tutorials, or sharing your workflow with others.

---

## Features

* Quick screen capture or video recording with custom directories
* Simple `ffmpeg` integration for snapshot and recording control
* Easy-to-use Neovim commands for automation and scripting
* Configurable output paths for images and videos

---

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "chriso345/schnapper.nvim",
  opts = {
    enabled = true,       -- Enable or disable the plugin
    img_dir = vim.fn.stdpath("cache") .. "/schnapper",
    video_dir = vim.fn.stdpath("cache") .. "/schnapper/videos",
    img_format = "png",   -- Anything supported by ffmpeg, e.g. "png", "jpg", "webp"
    video_format = "mp4", -- Anything supported by ffmpeg, e.g. "mp4", "mkv", "avi"
    video_fps = 30,       -- Frames per second for video recording
    os = "auto",          -- "win", "linux", "mac", "auto"
  }
}
```

---

## Usage

`schnapper.nvim` provides commands to control capturing and recording behavior. These can be triggered via the command-line or mapped to keys.

| Command             | Description                 |
| ------------------- | --------------------------- |
| `:SchnapperCapture` | Take a screenshot           |
| `:SchnapperRecord`  | Start recording the screen  |
| `:SchnapperStop`    | Stop and save the recording |

### Example Keymaps

```lua
vim.keymap.set("n", "<leader>sc", "<cmd>SchnapperCapture<CR>")
vim.keymap.set("n", "<leader>sr", "<cmd>SchnapperRecord<CR>")
vim.keymap.set("n", "<leader>ss", "<cmd>SchnapperStop<CR>")
```

---

## Requirements

* [ffmpeg](https://ffmpeg.org/) must be installed and available in your `$PATH`.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
