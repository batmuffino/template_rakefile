require('rubygems')
require('yaml')
require('logger') 
load('./rake_utils_gio.rb')
require('time')

task :default => [:help]

desc "show Help"
task :help do
    system ("cat README.rst")
end


desc "Main Task, do all the prerequsites" do
    task :main => []
    puts "Everything Done!"
end

desc "Check code quality of Python scripts. See https://dl.dropboxusercontent.com/u/7646235/my-best/index.htm"
task :quality do
    system "pyflakes src/ 2>&1 | tee logs/quality/latest_quality_report.txt"
    system "find src -iname '*.py' | parallel -j1 'python -m mccabe {}' 2>&1 | tee -a logs/quality/latest_quality_report.txt"
end

desc "Execute doctests and unittests"
task :test do |t|
    puts "Testing code"
#    system "nosetests --with-doctest --with-coverage --cover-package=src ."
    test_logfile = "logs/test_logs_" + Time.now.utc.iso8601 + ".log"
    system 'nosetests -v --with-doctest -A "not slow and not internet" . 2>&1 | tee ' + test_logfile
    #system "Rscript --vanilla test/run_tests.R 2>&1 | tee -a #{test_logfile}"
    system "cp #{test_logfile} logs/test_logs_latest.log" 
    puts "test logs saved to #{test_logfile}"
end




