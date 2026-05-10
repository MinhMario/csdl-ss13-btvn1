
DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
-- Lối logic: Đang lây ngày cũ ra số sánh vớt hiện tại thay vì kiểm tra ngày mứt
IF OLD.appointment_date < NOW( ) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Khong the dat lich kham vao thoi điem trong qua khu';
END IF;
END //

DELIMITER ;
DROP TRIGGER IF EXISTS PreventPastAppointments;
DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
IF NEW.appointment_date < NOW( ) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loi: Khong the dat lich kham vao thoi điem trong qua khu';
END IF;
END //

DELIMITER ;
-- giải thích: Giải thích sự khác biệt cốt lõi
-- OLD.appointment_date là giá trị trước khi cập nhật (ngày cũ đang lưu trong DB), còn NEW.appointment_date là giá trị người dùng muốn ghi vào (ngày mới). Trigger cần chặn khi NEW là ngày quá khứ — tức là ngày mới không hợp lệ.
-- Đoạn mã trên kiểm tra OLD < NOW() — tức là kiểm tra xem lịch cũ có phải quá khứ không, thay vì kiểm tra lịch mới. Kết quả là: nếu lịch cũ hợp lệ (tương lai), trigger không kích hoạt và cho phép ghi bất kỳ ngày mới nào kể cả ngày trong quá khứ.