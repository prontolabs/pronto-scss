require 'pronto'
require 'scss_lint'

module Pronto
  class Scss < Runner
    def initialize
      @runner = SCSSLint::Runner.new(SCSSLint::Config.default)
    end

    def run(patches, _)
      return [] unless patches

      scss_patches = patches.select { |patch| patch.additions > 0 }
                            .select { |patch| scss_file?(patch.new_file_full_path) }

      files = scss_patches.map { |patch| patch.new_file_full_path }

      if files.any?
        @runner.run(files)
        messages_for(scss_patches)
      else
        []
      end
    end

    def messages_for(scss_patches)
      @runner.lints.map do |lint|
        patch = patch_for_lint(scss_patches, lint)

        line = patch.added_lines.find do |added_line|
          added_line.new_lineno == lint.location.line
        end

        new_message(line, lint) if line
      end.flatten.compact
    end

    def patch_for_lint(scss_patches, lint)
      scss_patches.find do |patch|
        patch.new_file_full_path.to_s == lint.filename.to_s
      end
    end

    def new_message(line, lint)
      Message.new(line.patch.delta.new_file[:path], line, lint.severity, lint.description)
    end

    def scss_file?(path)
      %w(.css .scss).include?(File.extname(path))
    end
  end
end
