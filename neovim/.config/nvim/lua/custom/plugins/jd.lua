return {
  {
    "mfussenegger/nvim-jdtls",
    config = function()
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end
      vim.api.nvim_create_autocmd(
        "FileType",
        {
          pattern = "java",
          callback = function ()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            local homedir = vim.fn.getenv('HOME')
            local workspace_dir = homedir .. "/.workspace/" .. project_name -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
            local lombok_agent = "-javaagent:" .. homedir .. "/.local/share/java/lombok.jar",

            vim.lsp.set_log_level('DEBUG')
            local config = {
              -- The command that starts the language server
              -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
              cmd = {

                "java", -- or '/path/to/java17_or_newer/bin/java'

                lombok_agent,
                --"-Xbootclasspath/a:" .. homedir .. "/.local/share/java/lombok.jar",

                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-noverify",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                homedir .. "/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar",
                "-configuration",
                homedir .. "/.local/share/java/jdtls/config_linux",
                "-data",
                workspace_dir,
              },
              root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
              on_attach = on_attach,
              settings = {
                java = {
                  signatureHelp = {
                    enabled = true
                  },
                  contentProvider = {
                    preferred = 'fernflower'
                  },
                  configuration = {
                    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                    -- And search for `interface RuntimeOption`
                    -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                    runtimes = {
                      {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21",
                      },
                      {
                        name = "JavaSE-20",
                        path = "/usr/lib/jvm/java-20",
                      },
                      {
                        name = "JavaSE-19",
                        path = "/usr/lib/jvm/java-19"
                      },
                      {
                        name = "JavaSE-18",
                        path = "/usr/lib/jvm/java-18"
                      },
                      {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17"
                      },
                    }
                  }
                },
              },
            }
            require("jdtls").start_or_attach(config)
          end
        }
      )
    end
  }
}
