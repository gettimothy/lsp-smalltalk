;;; lsp-smalltalk.el --- Smalltalk support for lsp-mode

;; Version: 1.1
;; Package-Requires: ((emacs "27.1") (lsp-mode "3.0") (smalltalk-mode "4.0"))
;; Keywords: smalltalk
;; URL: https://github.com/emacs-lsp/lsp-smalltalk

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:

;; Smalltalk specific adapter for LSP mode

;;; Code:

(require 'lsp-mode)
(require 'smalltalk-mode)

;; ---------------------------------------------------------------------
;; Configuration

(defgroup lsp-smalltalk nil
  "Customization group for ‘lsp-smalltalk’."
  :group 'lsp-mode)

;; ---------------------------------------------------------------------
;; Language server options

;; These are registered with lsp-mode below, which handles preparing them for the server.
;; Originally generated from the vscode extension's package.json using lsp-generate-bindings.
;; Should ideally stay in sync with what's offered in the vscode extension.

(defcustom-lsp lsp-smalltalk-formatting-provider
  "ormolu"
  "The formatter to use when formatting a document or range.
Ensure the plugin is enabled."
  :group 'lsp-smalltalk
  :type '(choice (const "brittany") (const "floskell") (const "fourmolu") (const "ormolu") (const "stylish-smalltalk") (const "none"))
  :lsp-path "smalltalk.formattingProvider")
(defcustom-lsp lsp-smalltalk-check-project
  t
  "Whether to typecheck the entire project on load.
It could lead to bad perfomance in large projects."
  :group 'lsp-smalltalk
  :type 'boolean
  :lsp-path "smalltalk.checkProject")
(defcustom-lsp lsp-smalltalk-max-completions
  40
  "Maximum number of completions sent to the editor."
  :group 'lsp-smalltalk
  :type 'number
  :lsp-path "smalltalk.maxCompletions")
(defcustom-lsp lsp-smalltalk-session-loading
  "singleComponent"
  "Preferred approach for loading package components. Setting this
to 'multiple components' (EXPERIMENTAL) allows the build
tool (such as `cabal` or `stack`) to load multiple components at
once `https://github.com/smalltalk/cabal/pull/8726', which is a
significant improvement."
  :group 'lsp-smalltalk
  :type '(choice (const "singleComponent") (const "multipleComponents"))
  :lsp-path "smalltalk.sessionLoading")

;; ---------------------------------------------------------------------
;; Plugin-specific configuration
(defgroup lsp-smalltalk-plugins nil
  "Customization group for 'lsp-smalltalk' plugins."
  :group 'lsp-smalltalk)

(defcustom-lsp lsp-smalltalk-plugin-import-lens-code-actions-on
  t
  "Enables explicit imports code actions"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.importLens.codeActionsOn")
(defcustom-lsp lsp-smalltalk-plugin-import-lens-code-lens-on
  t
  "Enables explicit imports code lenses"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.importLens.codeLensOn")
(defcustom-lsp lsp-smalltalk-plugin-hlint-code-actions-on
  t
  "Enables hlint code actions (apply hints)"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.hlint.codeActionsOn")
(defcustom-lsp lsp-smalltalk-plugin-hlint-diagnostics-on
  t
  "Enables hlint diagnostics"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.hlint.diagnosticsOn")
(defcustom-lsp lsp-smalltalk-plugin-hlint-config-flags
  nil
  "Flags used by hlint"
  :group 'lsp-smalltalk-plugins
  :type 'lsp-string-vector
  :lsp-path "smalltalk.plugin.hlint.config.flags")
(defcustom-lsp lsp-smalltalk-plugin-eval-global-on
  t
  "Enables eval plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.eval.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-module-name-global-on
  t
  "Enables module name plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.moduleName.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-splice-global-on
  t
  "Enables splice plugin (expand template smalltalk definitions)"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.splice.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-haddock-comments-global-on
  t
  "Enables haddock comments plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.haddockComments.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-class-global-on
  t
  "Enables type class plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.class.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-retrie-global-on
  t
  "Enables retrie plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.retrie.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-stan-global-on
  t
  "Enables stan plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.stan.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-tactics-global-on
  t
  "Enables Wingman (tactics) plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.tactics.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-tactics-config-auto-gas
  4
  "The depth of the search tree when performing \"Attempt to fill hole\".
Bigger values will be able to derive more solutions,
but will take exponentially more time."
  :group 'lsp-smalltalk-plugins
  :type 'number
  :lsp-path "smalltalk.plugin.tactics.config.auto_gas")
(defcustom-lsp lsp-smalltalk-plugin-tactics-config-hole-severity
  nil
  "The severity to use when showing hole diagnostics."
  :group 'lsp-smalltalk-plugins
  :type '(choice (const 1) (const 2) (const 3) (const 4) (const nil))
  :lsp-path "smalltalk.plugin.tactics.config.hole_severity")
(defcustom-lsp lsp-smalltalk-plugin-tactics-config-max-use-ctor-actions
  5
  "Maximum number of `Use constructor <x>` code actions that can appear"
  :group 'lsp-smalltalk-plugins
  :type 'number
  :lsp-path "smalltalk.plugin.tactics.config.max_use_ctor_actions")
(defcustom-lsp lsp-smalltalk-plugin-tactics-config-timeout-duration
  2
  "The timeout for Wingman actions, in seconds"
  :group 'lsp-smalltalk-plugins
  :type 'number
  :lsp-path "smalltalk.plugin.tactics.config.timeout_duration")
(defcustom-lsp lsp-smalltalk-plugin-tactics-config-proofstate-styling
  t
  "Should Wingman emit styling markup when showing metaprogram proof states?"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.tactics.config.proofstate_styling")
(defcustom-lsp lsp-smalltalk-plugin-pragmas-code-actions-on
  t
  "Enables pragmas code actions"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.pragmas.codeActionsOn")
(defcustom-lsp lsp-smalltalk-plugin-pragmas-completion-on
  t
  "Enables pragmas completions"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.pragmas.completionsOn")
(defcustom-lsp lsp-smalltalk-plugin-ghcide-completions-config-auto-extend-on
  t
  "Extends the import list automatically when completing a out-of-scope identifier"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.ghcide-completions.config.autoExtendOn")
(defcustom-lsp lsp-smalltalk-plugin-ghcide-completions-config-snippets-on
  lsp-enable-snippet
  "Inserts snippets when using code completions"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.ghcide-completions.config.snippetsOn")
(defcustom-lsp lsp-smalltalk-plugin-ghcide-type-lenses-global-on
  t
  "Enables type lenses plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.ghcide-type-lenses.globalOn")
(defcustom-lsp lsp-smalltalk-plugin-ghcide-type-lenses-config-mode
  t
  "Control how type lenses are shown"
  :group 'lsp-smalltalk-plugins
  :type '(choice (const "always") (const "exported") (const "diagnostics"))
  :lsp-path "smalltalk.plugin.ghcide-type-lenses.config.mode")
(defcustom-lsp lsp-smalltalk-plugin-refine-imports-global-on
  t
  "Enables refine imports plugin"
  :group 'lsp-smalltalk-plugins
  :type 'boolean
  :lsp-path "smalltalk.plugin.refineImports.globalOn")

;; Updated for smalltalk-language-server 2.1.0.0

(lsp-defcustom lsp-smalltalk-plugin-cabal-code-actions-on t
  "Enables cabal code actions"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.cabal.codeActionsOn")

(lsp-defcustom lsp-smalltalk-plugin-cabal-completion-on t
  "Enables cabal completions"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.cabal.completionOn")

(lsp-defcustom lsp-smalltalk-plugin-pragmas-suggest-global-on t
  "Enables pragmas-suggest plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.pragmas-suggest.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-alternate-number-format-global-on t
  "Enables alternateNumberFormat plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.alternateNumberFormat.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-call-hierarchy-global-on t
  "Enables callHierarchy plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.callHierarchy.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-change-type-signature-global-on t
  "Enables changeTypeSignature plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.changeTypeSignature.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-class-code-actions-on t
  "Enables class code actions"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.class.codeActionsOn")

(lsp-defcustom lsp-smalltalk-plugin-class-code-lens-on t
  "Enables class code lenses"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.class.codeLensOn")

(lsp-defcustom lsp-smalltalk-plugin-eval-config-diff t
  "Enable the diff output (WAS/NOW) of eval lenses"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.eval.config.diff")

(lsp-defcustom lsp-smalltalk-plugin-eval-config-exception nil
  "Enable marking exceptions with `*** Exception:` similarly to doctest and GHCi."
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.eval.config.exception")

(lsp-defcustom lsp-smalltalk-plugin-explicit-fields-global-on t
  "Enables explicit-fields plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.explicit-fields.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-explicit-fixity-global-on t
  "Enables explicit-fixity plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.explicit-fixity.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-fourmolu-config-external nil
  "Call out to an external \"fourmolu\" executable, rather than using the bundled library"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.fourmolu.config.external")

(lsp-defcustom lsp-smalltalk-plugin-gadt-global-on t
  "Enables gadt plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.gadt.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-code-actions-bindings-global-on t
  "Enables ghcide-code-actions-bindings plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-code-actions-bindings.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-code-actions-fill-holes-global-on t
  "Enables ghcide-code-actions-fill-holes plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-code-actions-fill-holes.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-code-actions-imports-exports-global-on t
  "Enables ghcide-code-actions-imports-exports plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-code-actions-imports-exports.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-code-actions-type-signatures-global-on t
  "Enables ghcide-code-actions-type-signatures plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-code-actions-type-signatures.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-completions-global-on t
  "Enables ghcide-completions plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-completions.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-hover-and-symbols-hover-on t
  "Enables ghcide-hover-and-symbols hover"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-hover-and-symbols.hoverOn")

(lsp-defcustom lsp-smalltalk-plugin-ghcide-hover-and-symbols-symbols-on t
  "Enables ghcide-hover-and-symbols symbols"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ghcide-hover-and-symbols.symbolsOn")

(lsp-defcustom lsp-smalltalk-plugin-ormolu-config-external nil
  "Call out to an external 'ormolu' executable, rather than using the bundled library"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.ormolu.config.external")

(lsp-defcustom lsp-smalltalk-plugin-overloaded-record-dot-global-on t
  "Enables overloaded-record-dot plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.overloaded-record-dot.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-pragmas-completion-global-on t
  "Enables pragmas-completion plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.pragmas-completion.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-pragmas-disable-global-on t
  "Enables pragmas-disable plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.pragmas-disable.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-qualify-imported-names-global-on t
  "Enables qualifyImportedNames plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.qualifyImportedNames.globalOn")

(lsp-defcustom lsp-smalltalk-plugin-rename-config-cross-module nil
  "Enable experimental cross-module renaming"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.rename.config.crossModule")

(lsp-defcustom lsp-smalltalk-plugin-rename-global-on t
  "Enables rename plugin"
  :type 'boolean
  :group 'lsp-smalltalk-plugins
  :package-version '(lsp-mode . "8.0.1")
  :lsp-path "smalltalk.plugin.rename.globalOn")

;; ---------------------------------------------------------------------
;; Non-language server options

(defcustom lsp-smalltalk-server-path
  "smalltalk-language-server-wrapper"
  "The language server executable.
Can be something on the $PATH (e.g. 'ghcide') or a path to an executable itself."
  :group 'lsp-smalltalk
  :type 'string)

(defcustom lsp-smalltalk-server-log-file
  (expand-file-name "hls.log" temporary-file-directory)
  "The log file used by the server.
Note that this is passed to the server via 'lsp-smalltalk-server-args', so if
you override that setting then this one will have no effect."
  :group 'lsp-smalltalk
  :type 'string)

(defcustom lsp-smalltalk-server-args
  `("-l" ,lsp-smalltalk-server-log-file)
  "The arguments for starting the language server.
For a debug log when using smalltalk-language-server, use `-d -l /tmp/hls.log'."
  :group 'lsp-smalltalk
  :type '(repeat (string :tag "Argument")))

(defcustom lsp-smalltalk-server-wrapper-function
  #'identity
  "Use this to wrap the language server process started by lsp-smalltalk.
For example, use the following the start the process in a nix-shell:
\(lambda (argv)
  (append
   (append (list \"nix-shell\" \"-I\" \".\" \"--command\" )
           (list (mapconcat 'identity argv \" \"))
           )
   (list (concat (lsp--suggest-project-root) \"/shell.nix\"))
   )
  )"
  :group 'lsp-smalltalk
  :type '(choice
          (function-item :tag "None" :value identity)
          (function :tag "Custom function")))

;; ---------------------------------------------------------------------
;; Miscellaneous options
;;
(defcustom lsp-smalltalk-completion-in-comments
  t
  "Whether to trigger completions in comments.
Note that this must be set to true in order to get completion of pragmas."
  :group 'lsp-smalltalk
  :type 'boolean)

;; ---------------------------------------------------------------------
;; Starting the server and registration with lsp-mode

(defun lsp-smalltalk--server-command ()
  "Command and arguments for launching the inferior language server process.
These are assembled from the customizable variables `lsp-smalltalk-server-path'
and `lsp-smalltalk-server-args' and `lsp-smalltalk-server-wrapper-function'."
  (funcall lsp-smalltalk-server-wrapper-function (append (list lsp-smalltalk-server-path "--lsp") lsp-smalltalk-server-args) ))

(defun lsp-smalltalk--action-filter (command)
  "lsp-mode transforms JSON false values in code action
arguments to JSON null values when sending the requests back to
the server. We need to explicitly tell it which code action
arguments are non-nullable booleans."
  (lsp-fix-code-action-booleans command '(:restrictToOriginatingFile :withSig)))

;; This mapping is set for 'smalltalk-mode -> smalltalk' in the lsp-mode repo itself. If we move
;; it there, then delete it from here.
;; It also isn't *too* important: it only sets the language ID, see
;; https://microsoft.github.io/language-server-protocol/specification#textDocumentItem
(add-to-list 'lsp-language-id-configuration '(smalltalk-literate-mode . "smalltalk"))
(add-to-list 'lsp-language-id-configuration '(smalltalk-tng-mode . "smalltalk"))
(add-to-list 'lsp-language-id-configuration '(smalltalk-cabal-mode . "smalltalk"))

;; Register the client itself
(lsp-register-client
  (make-lsp--client
    :new-connection (lsp-stdio-connection (lambda () (lsp-smalltalk--server-command)))
    ;; Should run under smalltalk-mode, smalltalk-literate-mode and smalltalk-tng-mode. We need to list smalltalk-literate-mode even though it's a derived mode of smalltalk-mode.
    :major-modes '(smalltalk-mode smalltalk-literate-mode smalltalk-tng-mode smalltalk-cabal-mode)
    ;; This is arbitrary.
    :server-id 'lsp-smalltalk
    ;; HLS does not currently send 'workspace/configuration' on startup (https://github.com/smalltalk/smalltalk-language-server/issues/2762),
    ;; so we need to push the configuration to it manually on startup. We should be able to
    ;; get rid of this once the issue is fixed in HLS.
    :initialized-fn (lambda (workspace)
                      (with-lsp-workspace workspace
                        (lsp--set-configuration (lsp-configuration-section "smalltalk"))))
    :synchronize-sections '("smalltalk")
    ;; This is somewhat irrelevant, but it is listed in lsp-language-id-configuration, so
    ;; we should set something consistent here.
    :language-id "smalltalk"
    :completion-in-comments? lsp-smalltalk-completion-in-comments
    :action-filter #'lsp-smalltalk--action-filter
    ))

;; ---------------------------------------------------------------------

(provide 'lsp-smalltalk)
;;; lsp-smalltalk.el ends here
