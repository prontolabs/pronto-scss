require 'pronto'
require 'scss_lint'

module Pronto
  class Scss < Runner
    def run
      files = scss_patches.map(&:new_file_full_path)

      if files.any?
        files_hash =
          SCSSLint::FileFinder.new(scss_config).find(files).map do |path|
            { path: path }
          end
        runner.run(files_hash)
        messages
      else
        []
      end
    end

    def runner
      @runner ||= SCSSLint::Runner.new(scss_config)
    end

    def scss_config
      @scss_config ||= begin
        file_name = SCSSLint::Config::FILE_NAME
        if File.exist?(file_name) || File.symlink?(file_name)
          SCSSLint::Config.load(file_name)
        else
          SCSSLint::Config.default
        end
      end
    end

    def messages
      runner.lints.map do |lint|
        patch = patch_for_lint(lint)

        line = patch.added_lines.find do |added_line|
          added_line.new_lineno == lint.location.line
        end

        new_message(line, lint) if line
      end.flatten.compact
    end

    def patch_for_lint(lint)
      scss_patches.find do |patch|
        patch.new_file_full_path.to_s == lint.filename.to_s
      end
    end

    def scss_patches
      return [] unless @patches

      @scss_patches ||= @patches.select { |patch| patch.additions > 0 }
        .select { |patch| scss_file?(patch.new_file_full_path) }
    end

    def new_message(line, lint)
      Message.new(line.patch.delta.new_file[:path], line,
                  lint.severity, lint.description, nil, self.class)
    end

    def scss_file?(path)
      %w(.css .scss).include?(File.extname(path)) &&
        scss_files_option_matches?(path)
    end

    def scss_files_option_matches?(path)
      path_string = path.to_s
      files = scss_config.scss_files

      # We use `end_with?` because `path` is a absolute path and the file paths
      # of `scss_config.scss_files` are relative ones
      files.any? { |f| path_string.end_with?(f) }
    end
  end
end
