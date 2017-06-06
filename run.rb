require 'open3'

ITERATIONS = 6

module Run
  def self.main(data_path, *cases)
    times = Hash.new{|h, k| h[k] = []}

    cases.each do |case_dir|
      glob = File.join(data_path, case_dir, '*.*')
      files = Dir[glob].map(&:strip)
      if files.length == 0
        raise "No files found for #{glob}"
      end

      cmd = File.join(__dir__, 'runners', File.basename(case_dir))

      ITERATIONS.times do
        start = Time.now
        stdin, out, wait_thr = Open3.popen2e(cmd, *files)
        stdin.close
        puts out.read
        if !wait_thr.value.success?
          raise "#{case_dir} failed"
        end
        times[case_dir] << Time.now - start
      end
    end

    avgs = times.each_with_object({}) do |(k, vs), memo|
      memo[k] = vs[1..-1].sum / (ITERATIONS - 1)
    end

    puts "Raw times: #{times.inspect}"
    puts "Mean times (excluding first): #{avgs}"
  end
end

Run.main(*ARGV) if $0 == __FILE__
