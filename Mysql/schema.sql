DROP SCHEMA IF EXISTS CVS;
CREATE SCHEMA CVS;
use CVS;
/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2023/10/28 9:28:37                           */
/*==============================================================*/


/*==============================================================*/
/* Table: activity                                              */
/*==============================================================*/
create table activity
(
   activity_id          char(10) not null,
   activity_label_id    char(10) not null,
   address_id           char(10) not null,
   admin_id             varchar(10) not null,
   activity_name        varchar(20) not null,
   activity_introduction varchar(50) not null,
   activity_people_num  int not null,
   activity_request     varchar(50) not null,
   activity_begin       datetime not null,
   activity_end         datetime not null,
   activity_state       varchar(10),
   primary key (activity_id)
);

/*==============================================================*/
/* Table: activity_label                                        */
/*==============================================================*/
create table activity_label
(
   activity_label_id    char(10) not null,
   activity_label_name  varchar(20) not null,
   primary key (activity_label_id)
);

/*==============================================================*/
/* Table: admin                                                 */
/*==============================================================*/
create table admin
(
   admin_id             varchar(10) not null,
   admin_name           varchar(10) not null,
   admin_code           varchar(10) not null,
   check_result         varchar(10),
   check_time           datetime,
   check_back           varchar(50),
   primary key (admin_id)
);

/*==============================================================*/
/* Table: application                                           */
/*==============================================================*/
create table application
(
   application_id       varchar(10) not null,
   admin_id             varchar(10),
   normal_user_id       varchar(10) not null,
   activity_id          char(10) not null,
   application_reason   varchar(50),
   applicaiton_state    varchar(20) not null,
   application_time     datetime not null,
   primary key (application_id)
);

/*==============================================================*/
/* Table: comment                                               */
/*==============================================================*/
create table comment
(
   comment_id           char(10) not null,
   activity_id          char(10) not null,
   admin_id             varchar(10) not null,
   normal_user_id       varchar(10) not null,
   serve_hour           double not null,
   score                double not null,
   serve_comment        varchar(20) not null,
   primary key (comment_id)
);

/*==============================================================*/
/* Table: excellent_volunteer                                   */
/*==============================================================*/
create table excellent_volunteer
(
   excellent_volunteer_id varchar(10) not null,
   normal_user_id       varchar(10) not null,
   excellent_volunteer_dis varchar(50),
   primary key (excellent_volunteer_id)
);

/*==============================================================*/
/* Table: normal_user                                           */
/*==============================================================*/
create table normal_user
(
   normal_user_id       varchar(10) not null,
   org_id               char(10) not null,
   normal_user_name     varchar(10) not null,
   normal_user_code     varchar(20) not null,
   serve_duration       double not null,
   average_score        double not null,
   normal_user_state    bool,
   primary key (normal_user_id)
);

/*==============================================================*/
/* Table: organization                                          */
/*==============================================================*/
create table organization
(
   org_id               char(10) not null,
   org_name             varchar(20) not null,
   primary key (org_id)
);

/*==============================================================*/
/* Table: place                                                 */
/*==============================================================*/
create table place
(
   address_id           char(10) not null,
   address              varchar(100) not null,
   primary key (address_id)
);

alter table activity add constraint FK_举办地点_志愿活动 foreign key (address_id)
      references place (address_id) on delete restrict on update restrict;

alter table activity add constraint FK_活动标签_志愿活动 foreign key (activity_label_id)
      references activity_label (activity_label_id) on delete restrict on update restrict;

alter table activity add constraint FK_系统管理员_志愿活动 foreign key (admin_id)
      references admin (admin_id) on delete restrict on update restrict;

alter table application add constraint FK_check foreign key (admin_id)
      references admin (admin_id) on delete restrict on update restrict;

alter table application add constraint FK_志愿活动_活动申请 foreign key (activity_id)
      references activity (activity_id) on delete restrict on update restrict;

alter table application add constraint FK_普通用户_活动申请 foreign key (normal_user_id)
      references normal_user (normal_user_id) on delete restrict on update restrict;

alter table comment add constraint FK_志愿活动_服务评价 foreign key (activity_id)
      references activity (activity_id) on delete restrict on update restrict;

alter table comment add constraint FK_服务评价_普通用户 foreign key (normal_user_id)
      references normal_user (normal_user_id) on delete restrict on update restrict;

alter table comment add constraint FK_服务评价_系统管理员 foreign key (admin_id)
      references admin (admin_id) on delete restrict on update restrict;

alter table excellent_volunteer add constraint FK_普通用户_优秀志愿者 foreign key (normal_user_id)
      references normal_user (normal_user_id) on delete restrict on update restrict;

alter table normal_user add constraint FK_义工组织_普通用户 foreign key (org_id)
      references organization (org_id) on delete restrict on update restrict;





--
-- index: idx_label_name 方便用户进行活动类型的检索
--
create index idx_label_name on activity_label
(
	activity_label_name
);

--
-- index: idx_time 用于集中通过某一时刻的申请，方便管理员对特定时间段的申请进行审核（如批复时间不超过多少小时的规定）
--
create index idx_time on application
(
	application_time
);


--
-- Triggers for application
--

delimiter ;;
create trigger Get_Time_Before_Application
    before insert on application
    for each row
        begin
            set new.application_time = now();
        end ;;


--
Triggers for comment
--

delimiter ;; 
create trigger Update_time_and_comment after insert on comment
for each row
    begin
        update normal_user
        set
            normal_user.average_score = (normal_user.average_score * normal_user.serve_duration + new.score * new.serve_hour) 
            / (new.serve_hour + normal_user.serve_duration),
            normal_user.serve_duration = normal_user.serve_duration + new.serve_hour
        where
            normal_user.normal_user_id = new.normal_user_id;
		end ;;
     
--
Triggers for user_state
  

delimiter ;;
create trigger Set_User_State 
    before insert on normal_user
    for each row
        begin
            set new.normal_user_state = False;
        end ;;

        
--
-- Procedure structure for procedure `get_excellent_volunteer`
--  

delimiter ;;

create procedure get_excellent_volunteer()
begin
    select 
		ev.normal_user_id as id,
        nu.normal_user_name as user_name
    from 
		excellent_volunteer as ev,
        normal_user as nu
	where 
		nu.normal_user_id = ev.normal_user_id
    order by score desc
    limit 5;
end ;;

--
-- Procedure structure for procedure `Frozen_Account`
--  
delimiter ;;

create procedure Frozen_Account(in id varchar(10), in permission boolean)
begin
	update normal_user_id as nu
    set nu.normal_user_state = permission
	where nu.normal_user_id = id;
end ;;


