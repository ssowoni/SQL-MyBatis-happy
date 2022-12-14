

select * from tb_userinfo;

/*A : 관리자
  C : 학생
  D : 강사 */
  
  
 /*-----------------학습지원  - 공지사항 페이지------------------------------*/ 
 select bo.bd_no
        ,bo.bd_title
        ,bo.loginID
        ,bo.bd_date
        ,bo.bd_cnt
  from tb_board bo -- N
      ,tb_userinfo ui -- 1
  where bo.loginID = ui.loginID ;
  
  
  
  /* ansi sql 사용하기 inner join 사용하기 */ 
   select bo.bd_no
        ,bo.bd_title
        ,bo.loginID
        ,bo.bd_date
        ,bo.bd_cnt
    from tb_board bo -- N
       inner join tb_userinfo ui 
       on bo.loginID = ui.loginID-- 1
        -- limit 0,5 이 문법은 mysql 문ㅂㅓㅂ인ㄷㅔ 0부터 4까지 나오게 해
       ;
       
       
       
  /*----------------학습지원  -  수강상담이력 페이지------------------------------*/ 
   
   select li_nm
          /*
          ,li_date -- 강의시작
          ,li_redate -- 강의종료
          */
          ,CONCAT(li_date, ' ~ ' , li_redate) 기간 -- CONCAT 안에 넣으면 문자열 처리 가능
   from tb_lecinfo;
 
 
 /*1. 수강 신청 인원 수 정보 조회 */
 
  select loginID
         ,li_no
    from tb_subjectlist
    where li_no=1
    ;
    
  /*2. 참여 학생 목록 -> 강의 과저명 클릭했을 때 뜬다. (즉 과정을 듣는 학생들을 조회)*/
  
   select su.loginID
         ,su.li_no
         ,ui.name
    from tb_subjectlist su
          inner join tb_userinfo ui ON ui.loginID = su.loginID
    where li_no=1
    ;
    
    
    /*2. 참여 학생 목록 -> 시험에 참여한 학생 목록 조회 (전체다) */
    select li_no
           ,loginID
           ,sum(ss_score) score
      from tb_stdanswer
      group by li_no,loginID;
      
      
      
      /*2. 참여 학생 목록 -> 특정 과정 참여 학생 목록 + 시험 최종 점수 조횤 */ 
   SELECT su.loginID
          ,su.li_no
          ,ui.name
          ,ifnull(ll.score,0) score 
     FROM tb_subjectlist su
          inner join tb_userinfo ui on ui.loginID = su.loginID
          left outer join (   
                               -- 서브쿼리 안에 적은 as는 밖에서 쓸 수 없다.  만약 tb_stdanswer st 라고 지정해 준다면! 
                              select li_no -- 강의 코드
                                    ,loginID
                                    , sum(ss_score) score
                                from tb_stdanswer
                               group by li_no,loginID 
                          ) ll on su.loginID = ll.loginID and su.li_no = ll.li_no
     WHERE su.li_no = 1;
     
     
     
     
   /*3. 상담이력 목록조회 - 한건조회*/
   
   select li_no
         ,loginID
         ,cs_place
         ,cs_nm
     from tb_consult
     where li_no =1
      and loginID ='kim'
     
     ; 
     
     
   /*3. 상담이력 목록조회 - 강의번호, 상담일자, 상담장소, 상담자
        아래 방식은 join을 2번하게 된다. (강사 이름 가져오려면)*/
   
   select co.li_no
         ,co.loginID
         ,ui.name sname
         ,co.cs_place
         ,co.cs_nm
         ,ui2.name tname
     from tb_consult co
          inner join tb_userinfo ui ON ui.loginID = co.loginID
          inner join tb_userinfo ui2 ON ui2.loginID = co.cs_nm
     where co.li_no =1
      and co.loginID ='kim'
     
     ; 
     
     
     
     
     
          
  /*------------------학습 관리 - 설문 관리------------------------*/   
   
    /*점수, 참여인원 가져오기*/
  
  select li.li_no
        ,li.li_nm
        ,li.li_redate
        ,li.li_target
        ,li.loginID
        ,li.li_date
        ,li.li_redate
        ,ifnull(ll.stcnt,0) stcnt
        ,ifnull(stavgscore.avgscore,0) avgscore
   from tb_lecinfo li
        left outer join (
                            select li_no
                                  ,count(loginID) stcnt   
                              from tb_subjectlist
                             group by li_no
                        ) ll on ll.li_no = li.li_no
        left outer join (  
                            select li_no
                                  ,count(loginID) loginID
                                  ,sum(ss_score) ss_score
                                  ,ROUND(sum(ss_score) / count(loginID)) avgscore
                              from tb_stdanswer
                             group by li_no 
                        ) stavgscore on stavgscore.li_no = li.li_no;    
                        
                        
   
   
   
   
   
   
   select li_no
   ,loginID
          ,count(loginID) stcnt
       from tb_subjectlist
       group by li_no;
       
       
       
   
   
   
   select li_no
          ,count(loginID) loginID
          ,sum(ss_score) ss_score
          ,(sum(ss_score) / count(loginID)) avgscore
       from tb_stdanswer
       group by li_no;
       
       
       
       
       
    /*------------------학습 관리 - 시험문제  관리------------------------*/   
       
       
    select test_cd
      ,test_nm
      ,CASE  WHEN useyn = 'Y' THEN '사용중'
              ELSE '미사용'
       END as useyn
     from tb_questioninfo;
       
       
       
    select qst_cd
           ,qst_contents
           ,qst_answer
           ,score
    from tb_question
    where test_cd ='15';
   
   
   
   
   /*------------------인원 관리 - 강사  관리------------------------*/   
   
   
   select name   
         ,status_yn
         ,loginID
         ,password
         ,hp
         ,regdate
     from tb_userinfo
    where user_type = 'C';
     
     
    /*------------------취업 관리 - 취업정보------------------------*/   
    
    
    -- tb_employment에는 학생명이 없기에 inner join을 해줘야한다.
    select  em.em_no
          , em.loginID
          , ui.name
          , em.em_date
          , em.em_redate
          , em.em_nm
          , em.em_du
      from tb_employment em
        inner join tb_userinfo ui on em.loginID = ui.loginID
      ;
     
     
     
     
    /*------------------통계 - 만족도------------------------*/   
     
    
  select li.li_no
        ,li.li_nm
        ,concat(li.li_date, ' ~ ' ,li.li_redate) edudate
        ,ifnull(ll.stcnt,0) as stcnt
        ,ifnull(stavgscore.ss_score,0) as stavgscore
        ,ifnull(stavgscore.avgscore,0) as avgscore
        ,ifnull(stavgscore.max_ss_score,0) as max_ss_score
        ,ifnull(stavgscore.min_ss_score,0) as min_ss_score
   from tb_lecinfo li 
        left outer join (
                            select li_no
                                  ,count(loginID) stcnt   
                              from tb_subjectlist
                             group by li_no
                        ) ll on ll.li_no = li.li_no
        left outer join (  
                            select li_no
                                  ,count(loginID) loginID
                                  ,sum(ss_score) ss_score
                                  ,ROUND(sum(ss_score) / count(loginID)) avgscore
                                  ,max(ss_score) as max_ss_score
                                  ,min(ss_score) as min_ss_score
                              from tb_stdanswer
                             group by li_no 
                        ) stavgscore on stavgscore.li_no = li.li_no;
                        
                        
                        
                        
  
 select li.li_no
        ,li.li_nm
        ,concat(li.li_date, ' ~ ' ,li.li_redate) edudate
        ,ifnull(ll.stcnt,0) as stcnt
        ,ifnull(stavgscore.ss_score,0) as stavgscore
        ,ifnull(stavgscore.avgscore,0) as avgscore
        ,ifnull(stavgscore.max_ss_score,0) as max_ss_score
        ,ifnull(stavgscore.min_ss_score,0) as min_ss_score
   from tb_stdanswer st
        inner join tb_lecinfo li  on st.li_no = li.li_no
        left outer join (
                            select li_no
                                  ,count(loginID) stcnt   
                              from tb_subjectlist
                             group by li_no
                        ) ll on ll.li_no = st.li_no
        left outer join (  
                            select li_no
                                  ,count(loginID) loginID
                                  ,sum(ss_score) ss_score
                                  ,ROUND(sum(ss_score) / count(loginID)) avgscore
                                  ,max(ss_score) as max_ss_score
                                  ,min(ss_score) as min_ss_score
                              from tb_stdanswer
                             group by li_no 
                        ) stavgscore on stavgscore.li_no = st.li_no
  group by st.li_no                           
     
     