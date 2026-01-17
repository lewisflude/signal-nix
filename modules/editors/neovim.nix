# Signal Neovim Theme Module
#
# This module ONLY applies Signal colorscheme to neovim.
# It assumes you have already enabled neovim with:
#   programs.neovim.enable = true;
#
# The module will not install neovim, plugins, or configure LSP/Treesitter.
# You are responsible for installing:
#   - nvim-treesitter (optional, for better syntax highlighting)
#   - nvim-lspconfig (optional, for LSP semantic tokens)
#   - gitsigns.nvim (optional, for git integration)
{
  config,
  lib,
  pkgs,
  signalColors,
  signalLib,
  ...
}:
# CONFIGURATION METHOD: raw-config (Tier 4)
# HOME-MANAGER MODULE: programs.neovim.extraLuaConfig
# UPSTREAM SCHEMA: https://neovim.io/doc/user/syntax.html
# SCHEMA VERSION: 0.9.0
# LAST VALIDATED: 2026-01-17
# NOTES: Neovim requires Lua code for colorscheme definition. Home-Manager provides
#        extraLuaConfig for custom Lua. We generate complete colorscheme using
#        vim.api.nvim_set_hl. No structured options exist for custom themes.
let
  inherit (lib) mkIf;
  cfg = config.theming.signal;

  # Generate Neovim colorscheme in Lua format
  generateColorscheme =
    mode:
    let
      colors =
        if mode == "dark" then
          {
            # Base colors
            bg = signalColors.tonal."surface-subtle".hex;
            bg_alt = signalColors.tonal."surface-hover".hex;
            bg_highlight = signalColors.tonal."divider-primary".hex;
            fg = signalColors.tonal."text-primary".hex;
            fg_alt = signalColors.tonal."text-secondary".hex;
            fg_dim = signalColors.tonal."text-tertiary".hex;

            # Accent colors
            blue = signalColors.accent.secondary.Lc75.hex;
            cyan = signalColors.accent.secondary.Lc75.hex;
            green = signalColors.accent.primary.Lc75.hex;
            red = signalColors.accent.danger.Lc75.hex;
            orange = signalColors.accent.warning.Lc75.hex;
            purple = signalColors.accent.tertiary.Lc75.hex;

            # Categorical colors for syntax
            yellow = signalColors.categorical."data-viz-04".hex;
            magenta = signalColors.categorical."data-viz-05".hex;
            teal = signalColors.categorical."data-viz-02".hex;

            # UI colors
            border = signalColors.tonal."divider-primary".hex;
            cursor_line = signalColors.tonal."surface-hover".hex;
            cursor = signalColors.accent.secondary.Lc75.hex;
            selection = signalColors.tonal."divider-primary".hex;
            visual = signalColors.tonal."divider-primary".hex;

            # Git colors
            git_add = signalColors.accent.primary.Lc75.hex;
            git_change = signalColors.accent.secondary.Lc75.hex;
            git_delete = signalColors.accent.danger.Lc75.hex;

            # Diff colors
            diff_add = signalColors.tonal."surface-hover".hex;
            diff_delete = signalColors.tonal."surface-hover".hex;
            diff_change = signalColors.tonal."surface-hover".hex;
            diff_text = signalColors.tonal."divider-primary".hex;
          }
        else
          {
            # Light mode colors
            bg = "#f5f5f7";
            bg_alt = "#ececee";
            bg_highlight = "#d8d8dc";
            fg = "#25262f";
            fg_alt = "#5a5c6e";
            fg_dim = "#8e909f";

            blue = "#3557a0";
            cyan = "#3570a8";
            green = "#2d7a5e";
            red = "#b83226";
            orange = "#c97719";
            purple = "#7a5d8b";

            yellow = "#c97719";
            magenta = "#8a6d3b";
            teal = "#2d7a5e";

            border = "#d8d8dc";
            cursor_line = "#ececee";
            cursor = "#3557a0";
            selection = "#d8d8dc";
            visual = "#d8d8dc";

            git_add = "#2d7a5e";
            git_change = "#3557a0";
            git_delete = "#b83226";

            diff_add = "#e8f5f0";
            diff_delete = "#fce8e6";
            diff_change = "#e8eef8";
            diff_text = "#d8d8dc";
          };
    in
    pkgs.writeText "signal-${mode}.lua" ''
      -- Signal ${lib.toUpper (builtins.substring 0 1 mode)}${builtins.substring 1 (-1) mode} colorscheme
      -- Generated from Signal design system

      local colors = {
        bg = "${colors.bg}",
        bg_alt = "${colors.bg_alt}",
        bg_highlight = "${colors.bg_highlight}",
        fg = "${colors.fg}",
        fg_alt = "${colors.fg_alt}",
        fg_dim = "${colors.fg_dim}",
        
        blue = "${colors.blue}",
        cyan = "${colors.cyan}",
        green = "${colors.green}",
        red = "${colors.red}",
        orange = "${colors.orange}",
        purple = "${colors.purple}",
        yellow = "${colors.yellow}",
        magenta = "${colors.magenta}",
        teal = "${colors.teal}",
        
        border = "${colors.border}",
        cursor_line = "${colors.cursor_line}",
        cursor = "${colors.cursor}",
        selection = "${colors.selection}",
        visual = "${colors.visual}",
        
        git_add = "${colors.git_add}",
        git_change = "${colors.git_change}",
        git_delete = "${colors.git_delete}",
        
        diff_add = "${colors.diff_add}",
        diff_delete = "${colors.diff_delete}",
        diff_change = "${colors.diff_change}",
        diff_text = "${colors.diff_text}",
      }

      -- Clear existing highlights
      vim.cmd("highlight clear")
      if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
      end

      vim.o.termguicolors = true
      vim.g.colors_name = "signal-${mode}"

      local hi = vim.api.nvim_set_hl

      -- Editor highlights
      hi(0, "Normal", { fg = colors.fg, bg = colors.bg })
      hi(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
      hi(0, "NormalNC", { fg = colors.fg, bg = colors.bg })
      hi(0, "CursorLine", { bg = colors.cursor_line })
      hi(0, "CursorColumn", { bg = colors.cursor_line })
      hi(0, "LineNr", { fg = colors.fg_dim })
      hi(0, "CursorLineNr", { fg = colors.fg, bold = true })
      hi(0, "Visual", { bg = colors.visual })
      hi(0, "VisualNOS", { bg = colors.visual })
      hi(0, "Search", { fg = colors.bg, bg = colors.yellow })
      hi(0, "IncSearch", { fg = colors.bg, bg = colors.orange })
      hi(0, "Cursor", { fg = colors.bg, bg = colors.cursor })
      hi(0, "ColorColumn", { bg = colors.bg_alt })

      -- Window/Buffer
      hi(0, "VertSplit", { fg = colors.border })
      hi(0, "WinSeparator", { fg = colors.border })
      hi(0, "StatusLine", { fg = colors.fg, bg = colors.bg_alt })
      hi(0, "StatusLineNC", { fg = colors.fg_dim, bg = colors.bg_alt })
      hi(0, "TabLine", { fg = colors.fg_alt, bg = colors.bg_alt })
      hi(0, "TabLineFill", { bg = colors.bg_alt })
      hi(0, "TabLineSel", { fg = colors.fg, bg = colors.bg, bold = true })

      -- Popups/Menus
      hi(0, "Pmenu", { fg = colors.fg, bg = colors.bg_alt })
      hi(0, "PmenuSel", { fg = colors.bg, bg = colors.blue })
      hi(0, "PmenuSbar", { bg = colors.bg_highlight })
      hi(0, "PmenuThumb", { bg = colors.border })

      -- Syntax
      hi(0, "Comment", { fg = colors.fg_dim, italic = true })
      hi(0, "Constant", { fg = colors.orange })
      hi(0, "String", { fg = colors.green })
      hi(0, "Character", { fg = colors.green })
      hi(0, "Number", { fg = colors.orange })
      hi(0, "Boolean", { fg = colors.orange })
      hi(0, "Float", { fg = colors.orange })

      hi(0, "Identifier", { fg = colors.fg })
      hi(0, "Function", { fg = colors.blue })

      hi(0, "Statement", { fg = colors.purple })
      hi(0, "Conditional", { fg = colors.purple })
      hi(0, "Repeat", { fg = colors.purple })
      hi(0, "Label", { fg = colors.purple })
      hi(0, "Operator", { fg = colors.cyan })
      hi(0, "Keyword", { fg = colors.purple })
      hi(0, "Exception", { fg = colors.red })

      hi(0, "PreProc", { fg = colors.cyan })
      hi(0, "Include", { fg = colors.purple })
      hi(0, "Define", { fg = colors.purple })
      hi(0, "Macro", { fg = colors.cyan })
      hi(0, "PreCondit", { fg = colors.purple })

      hi(0, "Type", { fg = colors.yellow })
      hi(0, "StorageClass", { fg = colors.purple })
      hi(0, "Structure", { fg = colors.yellow })
      hi(0, "Typedef", { fg = colors.yellow })

      hi(0, "Special", { fg = colors.magenta })
      hi(0, "SpecialChar", { fg = colors.magenta })
      hi(0, "Tag", { fg = colors.blue })
      hi(0, "Delimiter", { fg = colors.fg_alt })
      hi(0, "SpecialComment", { fg = colors.cyan, italic = true })
      hi(0, "Debug", { fg = colors.red })

      hi(0, "Underlined", { underline = true })
      hi(0, "Bold", { bold = true })
      hi(0, "Italic", { italic = true })

      hi(0, "Error", { fg = colors.red })
      hi(0, "ErrorMsg", { fg = colors.red, bold = true })
      hi(0, "WarningMsg", { fg = colors.orange })
      hi(0, "Todo", { fg = colors.purple, bold = true })

      -- Treesitter
      hi(0, "@variable", { fg = colors.fg })
      hi(0, "@variable.builtin", { fg = colors.red })
      hi(0, "@variable.parameter", { fg = colors.orange })
      hi(0, "@variable.member", { fg = colors.teal })

      hi(0, "@constant", { fg = colors.orange })
      hi(0, "@constant.builtin", { fg = colors.orange })
      hi(0, "@constant.macro", { fg = colors.cyan })

      hi(0, "@string", { fg = colors.green })
      hi(0, "@string.regexp", { fg = colors.teal })
      hi(0, "@string.escape", { fg = colors.magenta })

      hi(0, "@character", { fg = colors.green })
      hi(0, "@number", { fg = colors.orange })
      hi(0, "@boolean", { fg = colors.orange })
      hi(0, "@float", { fg = colors.orange })

      hi(0, "@function", { fg = colors.blue })
      hi(0, "@function.builtin", { fg = colors.cyan })
      hi(0, "@function.macro", { fg = colors.cyan })
      hi(0, "@function.call", { fg = colors.blue })
      hi(0, "@method", { fg = colors.blue })
      hi(0, "@method.call", { fg = colors.blue })

      hi(0, "@constructor", { fg = colors.yellow })
      hi(0, "@parameter", { fg = colors.orange })

      hi(0, "@keyword", { fg = colors.purple })
      hi(0, "@keyword.function", { fg = colors.purple })
      hi(0, "@keyword.operator", { fg = colors.purple })
      hi(0, "@keyword.return", { fg = colors.purple })

      hi(0, "@conditional", { fg = colors.purple })
      hi(0, "@repeat", { fg = colors.purple })
      hi(0, "@label", { fg = colors.purple })

      hi(0, "@operator", { fg = colors.cyan })
      hi(0, "@exception", { fg = colors.red })

      hi(0, "@type", { fg = colors.yellow })
      hi(0, "@type.builtin", { fg = colors.yellow })
      hi(0, "@type.qualifier", { fg = colors.purple })

      hi(0, "@property", { fg = colors.teal })
      hi(0, "@field", { fg = colors.teal })

      hi(0, "@punctuation.delimiter", { fg = colors.fg_alt })
      hi(0, "@punctuation.bracket", { fg = colors.fg_alt })
      hi(0, "@punctuation.special", { fg = colors.magenta })

      hi(0, "@comment", { link = "Comment" })

      hi(0, "@tag", { fg = colors.blue })
      hi(0, "@tag.attribute", { fg = colors.yellow })
      hi(0, "@tag.delimiter", { fg = colors.fg_alt })

      -- LSP Semantic Tokens
      hi(0, "@lsp.type.namespace", { fg = colors.yellow })
      hi(0, "@lsp.type.type", { link = "@type" })
      hi(0, "@lsp.type.class", { link = "@type" })
      hi(0, "@lsp.type.enum", { link = "@type" })
      hi(0, "@lsp.type.interface", { link = "@type" })
      hi(0, "@lsp.type.struct", { link = "@type" })
      hi(0, "@lsp.type.parameter", { link = "@parameter" })
      hi(0, "@lsp.type.variable", { link = "@variable" })
      hi(0, "@lsp.type.property", { link = "@property" })
      hi(0, "@lsp.type.enumMember", { link = "@constant" })
      hi(0, "@lsp.type.function", { link = "@function" })
      hi(0, "@lsp.type.method", { link = "@method" })
      hi(0, "@lsp.type.macro", { link = "@constant.macro" })
      hi(0, "@lsp.type.decorator", { fg = colors.magenta })

      -- Git
      hi(0, "GitSignsAdd", { fg = colors.git_add })
      hi(0, "GitSignsChange", { fg = colors.git_change })
      hi(0, "GitSignsDelete", { fg = colors.git_delete })

      hi(0, "DiffAdd", { bg = colors.diff_add })
      hi(0, "DiffDelete", { bg = colors.diff_delete })
      hi(0, "DiffChange", { bg = colors.diff_change })
      hi(0, "DiffText", { bg = colors.diff_text })

      -- Diagnostics
      hi(0, "DiagnosticError", { fg = colors.red })
      hi(0, "DiagnosticWarn", { fg = colors.orange })
      hi(0, "DiagnosticInfo", { fg = colors.cyan })
      hi(0, "DiagnosticHint", { fg = colors.teal })

      hi(0, "DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
      hi(0, "DiagnosticUnderlineWarn", { sp = colors.orange, undercurl = true })
      hi(0, "DiagnosticUnderlineInfo", { sp = colors.cyan, undercurl = true })
      hi(0, "DiagnosticUnderlineHint", { sp = colors.teal, undercurl = true })
    '';

  # Generate both dark and light colorschemes
  darkColorscheme = generateColorscheme "dark";
  lightColorscheme = generateColorscheme "light";

  # Resolved mode for static theme selection
  themeMode = signalLib.resolveThemeMode cfg.mode;

  # Check if neovim should be themed
  # Check if neovim should be themed - using centralized helper
  shouldTheme = signalLib.shouldThemeApp "neovim" [
    "editors"
    "neovim"
  ] cfg config;
in
{
  config = mkIf (cfg.enable && shouldTheme) {
    # Assumes user has already set programs.neovim.enable = true
    # Only apply the color theme via extraLuaConfig
    programs.neovim.extraLuaConfig = ''
      -- Load Signal colorscheme
      ${
        if cfg.mode != "auto" then
          ''
            dofile("${if themeMode == "dark" then darkColorscheme else lightColorscheme}")
          ''
        else
          ''
            -- Auto mode: try to detect system theme
            -- Default to dark if detection fails
            dofile("${darkColorscheme}")
          ''
      }
    '';
  };
}
