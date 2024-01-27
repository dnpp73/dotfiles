path = ENV['IRB_HISTORY_PATH']
if path
  IRB.conf[:HISTORY_FILE] = path
end
