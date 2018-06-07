# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# DEBUG clear out any old data (not Students)
Presence.all.each {|e| e.delete}
HashValue.all.each {|e| e.delete}
ClassSession.all.each {|e| e.delete}

Room.all.each {|e| e.delete}
Room.create(number: 'Cafe', salt: 'salty salt')

AttendanceCode.all.each {|e| e.delete}
AttendanceCode.create(code: 0, desc: 'unknown')
AttendanceCode.create(code: 1, desc: 'Present')
AttendanceCode.create(code: 2, desc: 'Tardy')
AttendanceCode.create(code: 3, desc: 'Tardy Without Credit')

StartTime.all.each {|st| st.delete}
# create the StartTimes
# the last element is the time class starts when you have A lunch
REG = ['7:34', '8:36', '9:41', '10:43', '11:45', '1:21', '12:18'].freeze
SS = ['7:34', '8:31', '9:28', '10:55', '11:52', '1:26', '12:25'].freeze
DELAY = ['9:34', '10:17', '11:02', '11:45', '12:28', '1:40', '12:51'].freeze
MIN = ['7:34', '8:21', '9:11', '9:58', '10:45', '11:32', ''].freeze
[REG, SS, DELAY, MIN].each_with_index do |times, type|
	((1..6).to_a << 'LA').zip(times).to_h.each do |block, time|
		StartTime.create(time: time, block: block, schedule_type: type)
	end
end