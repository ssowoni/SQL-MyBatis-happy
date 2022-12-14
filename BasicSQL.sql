select * 
  from tb_employment;
  
select name
   from tb_userinfo;


/*select 문에서 조인*/
select ui.name 
      ,ui.loginID
      ,(select em.em_nm from tb_employment em where em.loginID = ui.loginID)
  from tb_userinfo ui
 where ui.loginID = 'DigitalOne';
 
 
 /*from절에서 조인
  웬만하면 from절에 적는 게 좋다. */
 select ui.name 
       ,ui.loginID
       ,ll.em_nm
   from tb_userinfo ui
       ,(
           select em.em_nm 
                 ,em.loginID
             from tb_employment em
             where em.loginID ='DigitalOne'
         ) ll
 where ll.loginID = ui.loginID   ;
 
 
 /* 특이한 쿼리 */
  select ui.name 
       ,ui.loginID
       ,ll.em_nm
   from tb_userinfo ui
       ,(
           select em.em_nm 
                 ,em.loginID
             from tb_employment em
             where em.loginID ='DigitalOne'
         ) ll
 where ll.loginID = ui.loginID 
  and(
        select count(*) from c
     ) > 10 ;
     
     
     
  select * 
    from tb_employment;
    
    
  /*1:1관계 쿼리문*/  
  select * 
  from tb_userinfo
  where loginID in  (  
                     select loginID
                       from tb_employment
                    --  group by loginID
                    ) ;
                    
                    
   /*1:n관계 쿼리문*/  
  select * 
  from tb_userinfo
  where (loginID,dddd) in  (  
                     select loginID, dddd
                       from tb_employment
                    --  group by loginID
                    ) ;   
                    
                    
                    
  /*강의가 한 번이라도 신청된 과정 번*/
  select li_no 
    FROM tb_subjectlist
    group by li_no
  ;
 
   
  select li_no 
      from tb_lecinfo;
      
      
 /*과정 생성은 되었으나 아무도 신청 안한 강의를 뽑아라*/
   select * 
      from tb_lecinfo
      where li_no not in(
                    select li_no 
                    FROM tb_subjectlist
                    group by li_no
      
                   )
      ;
    
    
    
       
    
    
     
     
  
  