select * from tb_userInfo;



-- 태희 11 페이지 
SELECT ui.user_name, ui.user_id, ui.user_regdate, ui.user_cnt, sum(pm.pay_total) pay_total
  FROM tb_userInfo ui RIGHT OUTER JOIN tb_payment pm on ui.user_id = pm.user_id 
 WHERE ui.user_id = pm.user_id 
 GROUP BY ui.user_id;
 
 
 
 /*
 case
                when li.li_type=1 then '재직자'
                else '실업자'
              end as 재직여부
 */
 
 -- 1. 상품 목록 조회 
 -- 1-1 조회 (1 = 요리류, 2=라면류, 3=음료류)
 
   select food_no 
         ,food_name
         ,food_price
         ,case
              when food_category=1 then '요리류'
              when food_category=2 then '라면류'
              else '음료류'
              end as 카테고리              
         ,food_image
         ,food_stCnt
    from tb_foodInfo;
    
  -- 1-2 키워드 조회 ( 타입별로) 
  
   select food_no 
         ,food_name
         ,food_price
         ,case
              when food_category=1 then '요리류'
              when food_category=2 then '라면류'
              else '음료류'
              end as 카테고리              
         ,food_image
         ,food_stCnt
    from tb_foodInfo
    where food_category=3;
    
  
 -- 2. 상품 클릭 시 상품 담기기
 -- 2-1 클릭한 상품들 목록에 조회
 -- 클릭 한 값은 사용자가 선택한 값을 받아서
  
  select food_name
        ,food_price
    from tb_foodInfo
    where food_no =1;
  
  
  -- 2-2 주문하기 버트ㄴ 누르면 tb_foodOrder에 클릭한 상품 담기기 
  insert into tb_foodOrder
  values (8,'user03',1,1,1500,now());
  
  -- 2-2 상품 주문 완료하면 tb_foodInfo에서 food_stCnt 값이 하나 줄어야 된다. 
  
  update tb_foodInfo 
  set food_stCnt =  food_stCnt -1
  where food_no =1
        and food_stCnt > 0
  ;
  
  select * from tb_foodInfo;
  select * from tb_foodOrder;
  
  
  
  
  -- 3. 결제 클릭 시 결제
  -- 3.1 음식주문내역의 음식 결제 총금액을 가져와서 sum으로 합쳐야한다. 
  
  select fsell_no 
         ,sum(order_mount) 음식전체결제금액
      from tb_foodOrder
      where user_id = 'user01'
      group by user_id, fsell_no;
   -- group by user_id;
   
   
  select  user_id
         , sum(order_mount) 음식전체결제금액
      from tb_foodOrder
      where user_id = 'user01';
      
  select * from tb_foodOrder;
     
   
   
  -- 3.2 pc좌석이용내역의 pc이용 총액 가져와서 sum으로 합친다. 
  -- as로 지정한 이용시간을 바로 밑에 컬럼에서 인식하지 못 한다.
  
  /*
  SELECT CONVERT(TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime), UNSIGNED) 이용시간
         ,(이용시간*1000) pc이용총금액
  FROM tb_pcUse;
   */
  -- 그렇기에 이렇게 2번 써주거나 아래처럼 서브쿼리 사용. 
  SELECT TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime) AS 이용시간
    ,(TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime)*1000) pc이용총금액
  FROM tb_pcUse;
  
  
  -- 서브쿼리 사용해야한다. 
  select ll.이용시간
        ,ll.이용시간 * 1000
    from (
           SELECT TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime) AS 이용시간
             FROM tb_pcUse
         ) ll;
  
 -- 사용자 use01이 사용한 좌석 금액
  select user_id
         ,puse_no
         ,(TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime)*1000) pc이용금액
     from tb_pcUse
     where user_id = 'user01';
     
     
     -- 사용자 user01의 총총 사용 합계
      select 
             ll.user_id
             ,ll.puse_no
             ,sum(ll.이용시간 * 1000) 
         from (
           SELECT TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime) AS 이용시간
                  ,user_id
                  ,puse_no
             FROM tb_pcUse
             where user_id='user01'
         ) ll;
     
     
  
  -- 3-3 결제 내역의 
  
  
  
  
  
  -- tb_payment 테이블의 pay_yn의 상태가 즉) 결제하지 않은 값들을 가져오자. 
  -- 회원 아이디, 음식가격
  select  pm.user_id
          ,fo.음식전체결제금액
    from tb_payment pm
   inner join (
                      select  user_id
                              ,fsell_no
                              ,sum(order_mount) 음식전체결제금액
                       from tb_foodOrder
                       where user_id = 'user01'
                     ) fo
                     -- on pm.user_id = fo.user_id
                     on pm.fsell_no = fo.fsell_no      
     where pay_yn = 0;
     
     
     
   -- tb_payment 테이블의 pay_yn의 상태가 즉) 결제하지 않은 값들을 가져오자. 
  -- 회원 아이디, 음식가격, pc 이용료 
  
  
   select  pm.user_id
          ,fo.음식전체결제금액
          ,pu.pc이용전체결제금액
    from tb_payment pm
    inner join (
                      select  user_id
                              ,fsell_no
                              ,sum(order_mount) 음식전체결제금액
                       from tb_foodOrder
                       where user_id = 'user01'
                 ) fo
                 -- on pm.user_id = fo.user_id
                 on pm.fsell_no = fo.fsell_no     
                 
     left outer join (
                           select 
                               ll.user_id
                               ,ll.puse_no
                               ,sum(ll.이용시간 * 1000) pc이용전체결제금액
                           from (
                             SELECT TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime) AS 이용시간
                                    ,user_id
                                    ,puse_no
                               FROM tb_pcUse
                               where user_id='user01'
                           ) ll
                      ) pu
                      on pu.puse_no = pm.puse_no
     where pay_yn = 0;
     
     
  
  
   -- tb_payment 테이블의 pay_yn의 상태가 즉) 결제하지 않은 값들을 가져오자. 
  -- 회원 아이디, 음식가격, pc 이용료 , 전체금액

  
  
  select  pm.user_id
          ,fo.음식전체결제금액
          ,pu.pc이용전체결제금액
          ,fo.음식전체결제금액+pu.pc이용전체결제금액 총금액
    from tb_payment pm
    inner join (
                      select  user_id
                              ,fsell_no
                              ,sum(order_mount) 음식전체결제금액
                       from tb_foodOrder
                       where user_id = 'user01'
                 ) fo
                 -- on pm.user_id = fo.user_id
                 on pm.fsell_no = fo.fsell_no     
                 
     left outer join (
                           select 
                               ll.user_id
                               ,ll.puse_no
                               ,sum(ll.이용시간 * 1000) pc이용전체결제금액
                           from (
                             SELECT TIMESTAMPDIFF(HOUR, pc_stTime, pc_eTime) AS 이용시간
                                    ,user_id
                                    ,puse_no
                               FROM tb_pcUse
                               where user_id='user01'
                           ) ll
                      ) pu
                      on pu.puse_no = pm.puse_no
     where pay_yn = 0;
  
  
   
   
      
  
  
  
  
  
  -- 3-n  결제 테이블에 pc좌석이용내역과 음식주문내역 담기 
  
  
  
  
  
  
            
        
 