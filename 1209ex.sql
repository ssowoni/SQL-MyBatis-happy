

  -- 공지사항 조회하기
  select bo.bd_no
       ,bo.bd_title
       ,bo.loginID
       ,bo.bd_date
       ,bo.bd_cnt
    from tb_board bo
         -- ,tb_userinfo ui
    ;
    
   -- ansi sql 사용
   select bo.bd_no
       ,bo.bd_title
       ,bo.loginID
       ,bo.bd_date
       ,bo.bd_cnt
    from tb_board bo
    inner join tb_userinfo ui
    on bo.loginID = ui.loginID;
    
    -- equi join 위의 2개와 결과 동일
     select bo.bd_no
       ,bo.bd_title
       ,bo.loginID
       ,bo.bd_date
       ,bo.bd_cnt
    from tb_board bo, tb_userinfo ui
    where bo.loginID = ui.loginID
    limit 0,5;
    
    
    
   /*----------------학습지원  -  수강상담이력 페이지------------------------------*/  
    
    
    select li_nm
           -- li_date,
           -- li_redate
           ,CONCAT(li_date, ' ~ ' , li_redate) 기간
      from tb_lecinfo;
  
  
   
   select li_no
          ,li_ap 
   from tb_lecinfo
   where tb_lecinfo.li_nm = 'spring';
   
   
   select *, count(li_no) 
   from tb_stdanswer
   group by li_no;
   
   
   
   /*2. 참여 학생 목록 -> 강의 과저명 클릭했을 때 뜬다. (즉 과정을 듣는 학생들을 조회)*/
   
    select  li.li_nm
            ,sl.loginID
            
      FROM tb_lecinfo li
      inner join tb_subjectlist sl
      on li.li_no = sl.li_no
      where li.li_no=1;
      
      
      -- 강의 번호가 1번인 강의를 듣는 사용자 정보 조회
      select  sl.li_no
              ,ui.loginID
             ,ui.name
      from tb_subjectlist sl
      inner join tb_userinfo ui
      ON ui.loginID = sl.loginID
      where sl.li_no=1;
        
      
     
    
    
    /*2. 참여 학생 목록 -> 시험에 참여한 학생 목록 조회 (전체다) */
    
    select li_no
           ,loginID
           ,max(ss_score)
     from tb_stdanswer 
     group by li_no, loginID;
    
    
    
    
      /*2. 참여 학생 목록 -> 특정 과정 참여 학생 목록 + 시험 최종 점수 조횤 */
      
      
      select  sl.li_no
              ,ui.loginID
              ,ui.name
              ,ifnull(ll.score,0) score 
      from tb_subjectlist sl
      inner join tb_userinfo ui ON ui.loginID = sl.loginID
      left outer join (select li_no
                       ,loginID
                       ,max(ss_score) score
                       from tb_stdanswer 
                       group by li_no, loginID
                       ) ll 
                       on sl.li_no = ll.li_no and sl.loginID = ll.loginID
      where sl.li_no=5;
  
  
  
  /*3. 상담이력 목록조회 - 한건조회*/
  select li_no
         ,cs_date
         ,cs_place
         ,cs_nm
     from tb_consult
     where li_no =1 and loginID = 'kim';
  
  
  select * from tb_lecinfo;
  
    /*3. 상담이력 목록조회 - 강의번호, 상담일자, 상담장소, 상담자
        아래 방식은 join을 2번하게 된다. (강사 이름 가져오려면)*/
  
   select li_no
         ,cs_date
         ,cs_place
         ,cs_nm
     from tb_consult 
     
     
     
     where li_no =1 and loginID = 'kim';
  
  
  
  select  sl.li_no
              ,ui.loginID
             ,ui.name
      from tb_subjectlist sl
      inner join tb_userinfo ui
      ON ui.loginID = sl.loginID
      where sl.li_no=1;
      
      
      /*------------------학습 관리 - 설문 관리------------------------*/   
   
    /*점수, 참여인원 가져오기*/
      
      
      
      select * from tb_lecinfo;
      
      select * from tb_userinfo;
      
      
      -- 1
      -- 강의 타입, 강의 이름, 강사ID(사용자이름), 등록일 
      -- 강의 타입을 조건을 걸어 출력하기
      select li.li_type
             ,case
                when li.li_type=1 then '재직자'
                else '실업자'
              end as 재직여부
             ,li.li_nm
             ,sl.loginID
             ,li.li_date
             ,li.li_redate
       
        from  tb_lecinfo li
              inner join tb_subjectlist sl
              on li.li_no = sl.li_no;
        
       
       -- 2  
       -- 강의의 총 평점 
       -- group by 기준으로, 그럼 현재는 li_no 기준으로 ,
       -- 그렇게 되면 강의 코드 기준이므로 강의 코드는 하나만 출력
       -- 만약 li_no, loginID를 적게 되면 같은 강의 코드여도 설문에 참여한 학생이 다르기에 강의 코드가 중복, 즉) 강의1 학생1, 강의1 학생2 이렇게 출력
       
       select li_no
              ,loginID
              ,avg(ss_score)
              ,count(loginID)
          from tb_stdanswer
         --  group by li_no, loginID;
           group by li_no;
        
        
        select count(li_no)
        from tb_stdanswer
        group by li_no;
        
        
        
        -- 알고보니 학생 답안지 tb_stdanswer 테이블이 아닌
        -- 설문조사 tb_survey 테이블에서 했어야 됨.
        select sv.li_no
              ,sv.loginID
              ,sv.sv_cj
              ,li.li_nm
          from tb_survey sv
               inner join tb_lecinfo li
               on li.li_no = sv.li_no
          order by li.li_nm
               ;
               
               
               
         select count(li_no)
         from tb_survey
         group by li_no;
               
               
         select li_no
                ,loginID
               --  ,count(li_no) svcount
               ,count(li_no)
                -- ,(sum(sv_cj) / svcount) svavgscore
                
            from tb_survey
          group by li_no, loginID;
        
        -- 3 
        
         select li.li_type
             ,case
                when li.li_type=1 then '재직자'
                else '실업자'
              end as 재직여부
             ,li.li_nm
             ,sl.loginID
             ,li.li_date
             ,li.li_redate
             ,stdavgscore.avgscore
             ,stdavgscore.stcount
       
        from  tb_lecinfo li 
              inner join tb_subjectlist sl
              on li.li_no = sl.li_no
        left outer join (
                           select li_no
                                  ,loginID
                                  ,avg(ss_score) avgscore
                                  ,count(loginID) stcount
                              from tb_stdanswer
                               group by li_no     
                        )  stdavgscore 
                        on  stdavgscore.li_no = li.li_no  
          WHERE NOT stdavgscore.avgscore is NULL;                              
              ;
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
       