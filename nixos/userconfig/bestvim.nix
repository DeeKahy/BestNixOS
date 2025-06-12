{
  pkgs,
  lib,
  ...
}: {
  vim = {
    lsp.enable = true;
    statusline = {
      lualine = {
        enable = true;
        theme = "tokyonight";
      };
    };

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete.nvim-cmp.enable = true;
    snippets.luasnip.enable = true;

    spellcheck = {
      enable = true;
    };

    lsp = {
      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = true;
    };
    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      ts.enable = true;
      rust.enable = true;
      python.enable = true;
    };
  };
}
