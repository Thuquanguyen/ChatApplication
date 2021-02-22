//
//  AnalyticsInfoKey.swift
//  AIC Utilities People
//
//  Created by IchNV-D1 on 9/5/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

struct AnalyticsInfoKey {
    
    enum Screen: String {
        case screen_home
        case screen_y_kien_nguoi_dan
        case screen_ve_tinh
        
        case screen_ca_nhan
   
        case screen_tro_ly_ao_thong_minh
        case screen_giao_thong
        case screen_mua_sam
        case screen_giai_tri
        case screen_doc_van_ban
        case screen_doc_bao
        case screen_giao_duc
        case screen_chuong_trinh_uu_dai
        
        case screen_dich_vu_cong
        case screen_cong_thong_tin_tu_thien
        case screen_thoi_tiet
        case screen_lich
        
        //Giao Thông
        case screen_cam_nang_giao_thong
        case screen_chi_tiet_bai_viet
        case screen_tien_ich_giao_thong
        case screen_dat_ve_uu_dai
        case screen_chi_tiet_dat_ve
        
        //Y tế
        case screen_y_te
        case screen_ban_do
        case screen_tim_kiem_dia_diem
        case screen_chi_tiet_dia_diem
        case screen_dat_lich_kham
        case screen_dat_lich_kham_truc_tiep
        case screen_chi_tiet_dat_lich_kham_truc_tiep
        case screen_goi_dien_thoai_cap_cuu
        case screen_chi_tiet_goi_dien_thoai_cap_cuu
        case screen_dat_lich_kham_truc_tuyen
        case screen_chi_tiet_dat_lich_kham_truc_tuyen
        case screen_tra_cuu_bmi
        case screen_tra_cuu_bhyt
        
        //Thông báo từ chính quyền
        case screen_thong_bao_tu_chinh_quyen
        case screen_chi_tiet_thong_bao_chinh_quyen
        
        //Thông báo khẩn cấp
        case screen_tin_tu_chinh_quyen
        case screen_tin_tu_nguoi_dan
        case screen_tat_ca_thong_bao
        case screen_chi_tiet_khan_cap
        case screen_bao_tin_khan_cap
        case screen_thong_bao_khan_cap
        case action_nghe_thong_bao_khan_cap
        case screen_chinh_sach_covid19
        
        //Ý kiến Người Dân
        case screen_tong_hop_y_kien
        case screen_chi_tiet_tin_phan_anh
        case screen_gui_hinh_anh
        case screen_gui_y_kien
        case screen_thong_ke_y_kien
        case screen_tong_hop_y_kien_nguoi_bi_cach_ly
        case screen_tim_kiem_dia_diem_qn
        
        //Dịch vụ công
        case screen_tra_cuu_dich_vu_cong
        case screen_tra_cuu_ho_so_dich_vu_cong
        case screen_chi_tiet_dich_vu_cong
        case screen_dich_vu_cong_pho_bien
        case screen_chi_tiet_dich_vu_cong_pho_bien
        case screen_dang_ky_dich_vu_cong
        case screen_dich_vu_cong_cua_toi
        case screen_chi_tiet_dich_vu_cong_cua_toi
        case screen_danh_gia_dich_vu_cong
        
        //Giáo dục & đào tạo
        case screen_giao_duc_voi_vtv7
        case screen_hoc_tieng_anh_come_to_live
        case screen_hoc_tieng_anh_trinity
        case screen_bai_giang_online
        case screen_chi_tiet_hoc_ngoai_ngu
        case screen_play_video
        case screen_hoc_nghe 
        case screen_danh_sach_bai_hoc_nghe
        case screen_chi_tiet_hoc_nghe
        
        //Giải trí
        case screen_doc_truyen
        case screen_danh_sach_truyen
        case screen_chi_tiet_truyen
        case screen_nghe_truyen
        case screen_danh_sach_game
        case screen_choi_game
        case screen_nghe_nhac
        case screen_xem_phim
        case screen_xem_phim_chi_tiet
        case screen_truyen_hinh_truc_tuyen
        
        //Phiên dịch
        case screen_phien_dich
        case screen_phien_dich_detail
        case screen_thong_dich
        
        //Đọc báo
        case screen_danh_sach_bao
        case screen_tim_kiem_bao
        case screen_chi_tiet_bao
        case screen_nghe_bao
        
        //Đọc văn bản
        case screen_quet_van_ban
        case screen_chon_anh
        case screen_chup_anh
        case screen_doc_van_ban_chi_tiet
        case screen_doc_tu_tap_tin
        
        //Cổng thông tin từ thiện
        case screen_hoan_canh_kho_khan
        case screen_chi_tiet_hoan_canh_kho_khan
        case screen_tu_thien_cua_toi
        case screen_chi_tiet_tu_thien_cua_toi
        case screen_chuong_trinh_tu_thien
        case screen_chi_tiet_chuong_trinh_tu_thien
        case screen_dang_ky_xin_tu_thien
        case screen_nha_hao_tam
        
        //Cá nhân hóa
        case screen_google
        case screen_zalo
        case screen_facebook
        case screen_noi_dung_da_luu
        case screen_chinh_sua_thong_tin
        case screen_login
        
        case screen_du_lich
        case screen_diem_tin
        case screen_tien_ich
        case screen_nguoi_yeu_the
        
        case screen_chi_tiet_tra_cuu_ho_so
        case screen_dang_nhap_dich_vu_cong
        case screen_thong_tin_ca_nhan_dich_vu_cong
        
        case screen_quan_trac_moi_truong
        case screen_ban_do_tram_xang
        case screen_tim_kiem_tram_xang
        case screen_ban_do_diem_do_xe
        case screen_tim_kiem_diem_do_xe
        case screen_ban_do_tram_thu_phi
        case screen_tim_kiem_tram_thu_phi
        case screen_ban_do_gara_oto
        case screen_tim_kiem_gara_oto
        case screen_ban_do_diem_den_giao_thong
        case screen_tim_kiem_diem_den_giao_thong
        case screen_ban_do_camera_giao_thong
        case screen_dat_ve_xe_may_bay
        case screen_danh_gia_dia_diem
        
        case screen_chi_tiet_van_ban_chi_dao
        case screen_thong_tin_chi_dao
        case screen_kiem_tra_thong_tin_thuoc
        case screen_tin_tuc_y_te

        case screen_ung_pho_tinh_huong_khan_cap
        case screen_chi_tiet_ung_pho_tinh_huong_khan_cap
        case screen_nau_an
        case screen_chi_tiet_nau_an
        case screen_ki_nang_mem
        case screen_chi_tiet_ki_nang_mem
        case screen_tin_hoc_ung_dung
        case screen_chi_tiet_tin_hoc_ung_dung
        case screen_hoc_online
        case screen_home_sport
        
        case tin_tu_bo_lao_dong_tbxh
        case screen_tin_nong_quoc_te
        case screen_tin_nong_trong_nuoc
        case screen_bao_trong_ngay
        case screen_tin_thoi_su

        case screen_cam_nang_du_lich
        case screen_video_le_hoi
        case screen_ban_do_du_lich
        case screen_huong_dan_vien_du_lich
        case screen_chon_ngon_ngu_cua_ban
        case screen_dat_tour_du_lich

        case screen_tim_kiem_ban_do_du_lich
        
        case screen_ban_do_mua_sam
        case screen_mua_sam_online
        case screen_giao_hang_online

        case screen_chon_ngon_ngu_cua_nguoi_noi_chuyen

        case screen_ho_tro_dich_thuat
        
        case screen_ho_tro_tre_em
        
        
        var name: String { return rawValue }
    }
    
    enum Button: String {
        // Home screen
        case action_tong_dai
        case action_email
        case action_goi_115
        case action_nghe_thong_bao_tu_chinh_quyen
        case action_choi_game
        case action_nghe_truyen
        case action_nghe_bao
        case action_mo_app_9999tet

        case action_tim_kiem_ho_so
        case screen_chi_tiet_tra_cuu_ho_so
        case screen_dang_nhap_dich_vu_cong
        case action_dang_nhap_dich_vu_cong
        case action_dang_xuat_dich_vu_cong
        case action_dang_ky_tai_khoan_dich_vu_cong
        case action_quen_tai_khoan_dich_vu_cong
        case screen_thong_tin_ca_nhan_dich_vu_cong
        case action_thay_doi_mat_khau_dich_vu_cong
        case action_chinh_sua_thong_tin_dich_vu_cong
        
        case action_danh_gia_dia_diem
        
        case action_goi_duong_day_nong

        case action_doi_kieu_hien_thi
        case action_nghe_bai_viet

        case action_chon_dau_bao
        case action_doi_kieu_hien_thi_bao_trong_ngay

        case action_goi_huong_dan_vien_du_lich

        case action_chon_ngon_ngu_cua_ban
        case action_chon_ngon_ngu_cua_nguoi_noi_chuyen

        case action_doi_ngon_ngu
        case action_nhap_van_ban
        case action_dao_hai_ngon_ngu
        case action_chi_tiet_phien_dich
        case action_sao_chep

        case action_truy_cap_web_dat_tour_du_lich
        case action_truy_cap_web_dat_phong_khach_san
        case action_truy_cap_web_dat_ve_may_bay
        case action_truy_cap_web_thue_xe

        case action_mo_app_khiem_thi
        case action_mo_app_khiem_thinh
        
        case action_goi_111
        case action_mo_app_tong_dai_111

        var name: String { return rawValue }
    }
    
    enum ParamKey: String {
        case id = "id"
        case title = "title"
        case url = "url"

        var name: String { return rawValue }
    }
}
