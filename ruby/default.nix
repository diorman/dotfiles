{... }:

{
  home.file.".gemrc".text = ''
    ---
    :update_sources: true
    :verbose: true
    :bulk_threshold: 1000
    :backtrace: false
    :benchmark: false
    gem: --no-document
  '';
}