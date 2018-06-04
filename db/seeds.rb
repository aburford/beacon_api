# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# clear out other data
Presence.all.each {|e| e.delete}
HashValue.all.each {|e| e.delete}
ClassSession.all.each {|e| e.delete}
Room.all.each {|e| e.delete}
AttendanceCode.all.each {|e| e.delete}

AttendanceCode.create(code: 0) # unknown
AttendanceCode.create(code: 1) # present
AttendanceCode.create(code: 2) # tardy

Room.create(number: 123, salt: 'salty salt')
r = Room.find_by(number: 123)
#ClassSession.create(room: r, start_time: '12:07', period: 2)
# ClassSession.create(room: r, start_time: '9:49', period: 3)
# ClassSession.create(room: r, start_time: '11:49', period: 4)

unknown = AttendanceCode.find_by(code: 0)
ClassSession.all.each do |cs|
	Presence.create(class_session: cs, student: Student.last, attendance_code: unknown)
end
