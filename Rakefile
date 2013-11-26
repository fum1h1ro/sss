# vim: fenc=utf-8
# encoding: utf-8
dirs = %w(sss)

task :default do
    dirs.each do |d|
        chdir(d) { sh "rake" }
    end
end
