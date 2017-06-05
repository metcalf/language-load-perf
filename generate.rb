require 'optparse'
require 'erb'
require 'fileutils'

module Generate
  def self.parse_args(args)
    options = {
      methods: 30,
      files: 5000,
      output: File.join(__dir__, 'data'),
    }
    cases = args.dup

    OptionParser.new do |opts|
      opts.on('--methods=N', 'Number of methods per file') do |v|
        options[:methods] = v.to_i
      end
      opts.on('--files=N', 'Number of files') do |v|
        options[:files] = v.to_i
      end
      opts.on('--output=/path/to/directory', 'Output directory') do |v|
        options[:output] = File.expand_path(v, __dir__)
      end
    end.parse!(cases)

    [options, cases]
  end

  def self.main(args)
    options, cases = parse_args(args)

    data = Array.new(options[:files]) do |cid|
      methods = Array.new(options[:methods]) do |mid|
        ["c#{cid}m#{mid}", "#{cid}-#{mid}"]
      end

      ["C#{cid}", methods]
    end

    cases.each do |cs|
      erb_path = File.join(__dir__, 'templates', cs)
      case_dir, ext, = cs.split('.')
      case_name = File.basename(case_dir)
      out_path = File.join(options[:output], case_dir)

      tmpl = ERB.new(File.read(erb_path))

      if File.exist?(out_path)
        raise "Path already exists: #{out_path}"
      end
      FileUtils.mkdir_p(out_path)

      data.each do |class_name, methods|
        File.write(File.join(out_path, "#{case_name}-#{class_name}.#{ext}"), tmpl.result(binding))
      end
    end
  end
end

Generate.main(ARGV) if $0 == __FILE__
