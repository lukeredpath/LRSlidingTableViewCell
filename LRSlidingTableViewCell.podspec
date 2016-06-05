Pod::Spec.new do |s|
  s.name     = 'LRSlidingTableViewCell'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'A simple implementation of sliding table cells, first seen in Tweetie for iPhone.'
  s.homepage = 'https://github.com/pandamonia/LRSlidingTableViewCell'
  s.author   = { 'Alexsander Akers' => 'a2@pandamonia.us',
                 'Luke Redpath' => 'luke@lukeredpath.co.uk' }
  s.source   = { :git => 'https://github.com/pandamonia/LRSlidingTableViewCell.git', :tag => 'v1.0' }
  s.platform = :ios
  s.source_files = 'SlidingTableCell/LRSlidingTableViewCell.{h,m}'
  s.clean_paths  = 'SlidingTableCell.xcodeproj/', 'SlidingTableCell/Sample/'
  s.requires_arc = true
end
