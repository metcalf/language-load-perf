require 'open3'

module Run
  def self.main(data_path, *cases)
    times = {}

    cases.each do |case_name|
      glob = File.join(data_path, case_name, '*')
      files = Dir[glob].map(&:strip)
      if files.length == 0
        raise "No files found for #{glob}"
      end

      cmd = File.join(__dir__, 'runners', case_name)

      start = Time.now

      stdin, out, wait_thr = Open3.popen2e(cmd, *files)
      stdin.close
      puts out.read
      if !wait_thr.value.success?
        raise "#{case_name} failed"
      end
      times[case_name] = Time.now - start
    end

    puts times
  end
end

Run.main(*ARGV) if $0 == __FILE__
