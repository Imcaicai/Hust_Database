use finance1;

-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
delimiter $$
create procedure sp_transfer(
	                 IN applicant_id int,      
                     IN source_card_id char(30),
					 IN receiver_id int, 
                     IN dest_card_id char(30),
					 IN	amount numeric(10,2),
					 OUT return_code int)
BEGIN

set autocommit = off;
start transaction;
update bank_card set b_balance=b_balance-amount where b_number=source_card_id and b_c_id=applicant_id and b_type='储蓄卡';
update bank_card set b_balance=b_balance+amount where b_number=dest_card_id and b_c_id=receiver_id and b_type='储蓄卡';
update bank_card set b_balance=b_balance-amount where b_number=dest_card_id and b_c_id=receiver_id and b_type='信用卡';

# 如果付款的储蓄卡余额<=0，则转出失败，事务回滚
if not exists(select* from bank_card where b_number=source_card_id and b_c_id=applicant_id and b_type='储蓄卡' and b_balance>=0) then
    set return_code=0;
    rollback;
# 如果收款方客户编号或卡号不存在，则转出失败，事务回滚
elseif not exists(select* from bank_card where b_number=dest_card_id and b_c_id=receiver_id) then 
    set return_code=0;
    rollback;
else
    set return_code=1;
    commit;
end if;
END$$
delimiter ;

/*  end  of  your code  */ 